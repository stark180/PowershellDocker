# PowershellDocker

DevOps Task
Create a PowerShell 'DockerHelper' module containing 3 cmdlets
Build-DockerImage
The cmdlet builds a Docker image from the $Dockerfile with a name $Tag on a remote host $ComputerName, where Docker is installed. If $ComputerName is omitted cmdlet is executed locally.
Mandatory parameters:

-Dockerfile <String> (path to a Dockerfile, which is used for building an image)
-Tag <String> (Docker image name)
-Context <String> (path to Docker context directory)

Optional parameteres:

-ComputerName <String> (name of a computer, where Docker is installed)

Copy-Prerequisites
The cmdlet copies files and/or directories from $Path on a local machine to $ComputerName local $Destination directory (these files could be reqired by some Dockerfiles). Assuming you have admin access to a remote host, and you are able to use admin shares C$, D$, etc.
Mandatory parameters:

-ComputerName <String> (name of a remote computer)
-Path <String[]> (local path(s) where to copy files from)
-Destination <String> (local path on a remote host where to copy files)

Run-DockerContainer
Run container on a remote host. If $ComputerName is omitted cmdlet is executed locally. Returns container name.
Mandatory parameters:

-ImageName <String>

Optional parameters:

-ComputerName <String>
-DockerParams <String[]>

Outputs:\

<String>
Container name.

You can add any number of other optional parameter if it is necessary.

Using 'DockerHelper' module run a Fibonacci container
When you do not pass any parameters to the container, it outputs all Fibonacci numbers one by one every 0.5 second.
When you pass a number n to the container, it outputs only corresponding Fibonacci number - X(n)
All scripts must be written in PowerShell
The outcome of this task are:

Dockerfile
all other files required to build the docker image (if applicable)
