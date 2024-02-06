param(
    [int]$n = -1  # Default value -1 indicates continuous Fibonacci sequence
)

# Function to generate Fibonacci numbers
function Get-Fibonacci {
    param(
        [int]$count  # Number of Fibonacci numbers to generate
    )
    
    $fibonacci = @(0, 1)
    
    for ($i = 2; $i -lt $count; $i++) {
        $fibonacci += $fibonacci[$i - 1] + $fibonacci[$i - 2]
    }
    
    return $fibonacci
}

# Continuous Fibonacci sequence
if ($n -eq -1) {
    while ($true) {
        Get-Fibonacci -count 1 | Write-Output
        Start-Sleep -Milliseconds 500
    }
}
# Generate Fibonacci number up to n
else {
    Get-Fibonacci -count $n | Select-Object -Last 1 | Write-Output
}
