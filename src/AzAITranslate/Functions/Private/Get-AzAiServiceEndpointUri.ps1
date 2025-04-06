<#PSScriptInfo

.VERSION 1.0.0

.GUID bae25342-d78f-4b89-b993-739c32a0e561

.AUTHOR diko@admins-little-helper.de

.COMPANYNAME

.COPYRIGHT (c) 2025 All rights reserved.

.TAGS Azure AI Translator

.LICENSEURI https://github.com/admins-little-helper/AzAiTranslate/blob/main/LICENSE

.PROJECTURI https://github.com/admins-little-helper/AzAiTranslate

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
    1.0.0
    Initial release
#>


<#

.DESCRIPTION
Get the service endpoint URI of the specified service endpoint from a list of known endpoint URIs.

#>


function Get-AzAiServiceEndpointUri {
    <#
    .SYNOPSIS
        Get the service endpoint URI of the specified service endpoint from a list of known endpoint URIs.

    .DESCRIPTION
        The 'Get-AzAiServiceEndpointUri' returns the service endpoint URI of the specified service endpoint from a list of known endpoint URIs.

    .PARAMETER ServiceEndpoint
        Specifies the service endpoint to use. Can by any of "Global", "Americas", "AsiaPacific", "Europe", "Custom".
        Defaults to whatever has been set as ServiceEndpointToUse using the 'Set-AzAiSessionSettings' function (which itself defaults to 'Global').

    .EXAMPLE
        Get-AzAiServiceEndpointUri -ServiceEndpoint "Europe"

        This will return the service endpoint URI of the european endpoint.

    .EXAMPLE
        Get-AzAiServiceEndpointUri

        This will return the service endpoint URI of the service endpoint that is specified in the sessions variable 'ServiceEndpointToUse' property (by default the global service endpoint).

    .INPUTS
        Nothing

    .OUTPUTS
        System.String

    .NOTES
        Author:     diko@admins-little-helper.de
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Get-AzAiServiceEndpointUri.md
    #>
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Specify the service endpoint for which to return the endpoint URI.")]
        [ValidateSet("Global", "Americas", "AsiaPacific", "Europe", "Custom")]
        [String]
        $ServiceEndpoint = $Script:AzAiSession.ServiceEndpointToUse
    )

    switch ($ServiceEndpoint) {
        "Custom" {
            if ([string]::IsNullOrEmpty($Script:AzAiSession.ServiceEndpoints.Custom)) {
                # Show a warning in case no custom endpoint URI has been specified so far.
                Write-Warning -Message "No custom service endpoint URI has been set yet. Run 'Set-AzAiSessionSettings' with parameter 'ServiceEndpointUri' to set the URI for the custom service endpoint."
                Write-Warning -Message "Falling back to 'Global' service endpoint URI."
                # Return the global service endpoint URI as fall back solution.
                $Script:AzAiSession.ServiceEndpoints.Global
            }
            else {
                # Return the custom service endpoint URI.
                $Script:AzAiSession.ServiceEndpoints.Custom
            }
            break
        }
        default {
            # Return the specified service endpoint URI.
            $Script:AzAiSession.ServiceEndpoints.$ServiceEndPoint
        }
    }
}