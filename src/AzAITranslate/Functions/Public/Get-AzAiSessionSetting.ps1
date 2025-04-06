<#PSScriptInfo

.VERSION 1.0.0

.GUID 9fc41651-b9ba-490d-abf3-30eb535d29a6

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
Return the AzAiTranslate session variable.

#>


function Get-AzAiSessionSetting {
    <#
    .SYNOPSIS
        Returns the AzAiTranslate session variable.

    .DESCRIPTION
        The 'Get-AzAiSessionSetting' returns the AzAiTranslate session variable.

    .EXAMPLE
        $Var = Get-AzAiSessionSetting

        Returns the AzAiTranslate session variable.

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     diko@admins-little-helper.de
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Get-AzAiSessionSetting.md
    #>
    [CmdletBinding()]
    param ()

    # Return the AzAiSession variable.
    Write-Verbose -Message "Return the AzAiSession variable."
    return $Script:AzAiSession
}