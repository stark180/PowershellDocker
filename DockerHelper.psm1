# Function to build Docker image
function Build-DockerImage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] 
        [ValidateScript({Test-Path $_ -PathType Leaf})] 
        [string]$Dockerfile,  # Path to the Dockerfile

        [Parameter(Mandatory)] 
        [string]$Tag,  # image tag

        [Parameter(Mandatory)] 
        [string]$Context,  # Path to Docker context directory

        [string]$ComputerName  # Name of the remote host
    )

    # Parameters for Copy-Item
    $copyParams = @{
        FilePath = $Dockerfile
        Destination = "$Context\Dockerfile"
    }
    
    # Check if the ComputerName is provided
    if ($ComputerName) {
        # Establish a PowerShell session to the remote host
        $session = New-PSSession -ComputerName $ComputerName
        # Copy the Dockerfile to the remote context directory
        Copy-Item @copyParams -ToSession $session
        # Execute the Docker build command remotely
        $output = Invoke-Command -Session $session -ScriptBlock {
            docker build -t $using:Tag -f $using:Context\Dockerfile $using:Context
        }
        # Remove the PowerShell session
        Remove-PSSession -Session $session
    }
    else {
        # Copy the Dockerfile locally
        Copy-Item @copyParams
        # Execute the Docker build command locally
        $output = docker build -t $Tag -f $Dockerfile $Context
    }

    # Return Docker build output
    return $output
}

# copy prerequisites to a remote host
function Copy-Prerequisites {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] 
        [string]$ComputerName,  # Name of the remote host

        [Parameter(Mandatory)] 
        [ValidateScript({Test-Path $_ -PathType Container})] 
        [string[]]$Path,  # Paths to copy from

        [Parameter(Mandatory)] 
        [string]$Destination  # Destination path on the remote host
    )

    # Establish a PowerShell session to the remote host
    $session = New-PSSession -ComputerName $ComputerName
    # Copy each item from the local machine to the remote destination
    foreach ($p in $Path) {
        Copy-Item -Path $p -Destination $Destination -ToSession $session -Recurse  # Recursively copy directories
    }
    # Remove the PowerShell session
    Remove-PSSession -Session $session
}

# Function to run a Docker container
function Run-DockerContainer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] 
        [string]$ImageName,  # Docker image name

        [string]$ComputerName,  # Name of the remote host

        [string[]]$DockerParams  # parameters for Docker run command
    )

    # Check if the ComputerName is provided
    if ($ComputerName) {
        # Establish a PowerShell session to the remote host
        $session = New-PSSession -ComputerName $ComputerName
        # Run the Docker container remotely
        $containerName = Invoke-Command -Session $session -ScriptBlock {
            docker run -d $using:ImageName $using:DockerParams
        }
        # Remove the PowerShell session
        Remove-PSSession -Session $session
    }
    else {
        
        $containerName = docker run -d $ImageName $DockerParams
    }

    # Return the name of the container
    return $containerName
}
