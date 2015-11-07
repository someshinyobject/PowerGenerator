$TemplateArray = @(
    "Hello, my name is |_name_|",
    "Hello, my name is |_ name _|",
    "Hello, my name is |_name",
    "Hello, my name is |_name_| and I have a pet |_pet_|"
)

$VariableNames = @("name", "name", @(), @("name","pet"))

$Regex = @{
    "TemplateVariable" = [regex]"\|_\s*([A-Za-z0-9_\-@$]*)\s*_\|"
}

Function Read-TemplateVariable {
    [CmdletBinding()]
    [Alias()]
    Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True, Position = 0)]
        [Object]$Line
    )
    Begin {
        $Captures = @()
        $Matches = $Regex.TemplateVariable.Matches($Line)
    }
    Process {
        ForEach ($Match in $Matches) {
            $Captures += $Match.Groups[1].Value
        }
    }
    End {
        $Captures
    }
}


Describe "Grab Templating Variable" {
	Context "Grabs variable name |_variable_|" {
		It "Should Return" {
            $Variables = $TemplateArray | ForEach-Object {
                Read-TemplateVariable -Line $_
            } 
            $Variables | Should Be $VariableNames
		}
	}
}