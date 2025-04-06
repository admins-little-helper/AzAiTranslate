<#PSScriptInfo

.VERSION 1.0.0

.GUID 70ff22b8-4af9-4c58-a9a7-3f70cb771a90

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
Translate a single document from one language to another using Azure AI Translator REST API.

#>


function Invoke-AzAiTranslateDocument {
    <#
    .SYNOPSIS
        Translate a single document from one language to another using Azure AI Translator REST API.

    .DESCRIPTION
        The 'Invoke-AzAiTranslateDocument' translates a single document from one language to another using Azure AI Translator REST API.

    .PARAMETER InputFile
        The filepath to the input document to translate.

    .PARAMETER OutputFile
        The filepath to the output file.

    .PARAMETER GlossaryFile
        The filepath to a glossary file containing customize translations.

    .PARAMETER To
        The target language (for example 'en').

    .PARAMETER From
        The source language (for example 'de').

    .PARAMETER ServiceEndpoint
        The service endpoint to use. Can by any of "Global", "Americas", "AsiaPacific", "Europe".

    .PARAMETER SubsriptionKey
        The subscript key (API key) of your Azure AI Translator subscription.

    .PARAMETER SubscriptionRegion
        The region of the multi-service or regional translator resource.

    .PARAMETER DocumentApiVersion
        The ApiVersion to use for document translation.

    .PARAMETER AllowFallback
        Specify that the service is allowed to fall back to a general system when a custom system doesn't exist

    .PARAMETER Category
        A string specifying the category (domain) for the translation. This parameter is used to get translations from a customized system built with Custom Translator.

    .PARAMETER Force
        If specified, overwrites an eventually existing output file.

    .EXAMPLE
        Invoke-AzAiTranslateDocument -InputFile C:\Temp\TranslateThis.txt -OutputFile C:\Temp\TranslationResult.txt -From 'en' -To 'de'

        This will translate the content of 'C:\Temp\TranslateThis.txt' from English to German and save the result in 'C:\Temp\TranslationResult.txt'.

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     diko@admins-little-helper.de
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Invoke-AzAiTranslateDocument.md
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False positive as rule does not scan child scopes')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, HelpMessage = "The input document to translate.")]
        [System.IO.FileInfo]
        $InputFile,

        [Parameter(Mandatory = $true, HelpMessage = "The file path for the translated document.")]
        [System.IO.FileInfo]
        $OutputFile,

        [Parameter(HelpMessage = "Path to the file location for your custom glossary.")]
        [System.IO.FileInfo]
        $GlossaryFile,

        [Parameter(Mandatory = $true, HelpMessage = "Specifies the target language.")]
        [ArgumentCompleter({
                Param (
                    $Command,
                    $Parameter,
                    $WordToComplete,
                    $CommandAst,
                    $FakeBoundParameters
                )

                # Get the session variable content.
                $AzAiSessionTemp = Get-AzAiSessionSetting

                # Get the list of language codes retrieved from the session variable.
                $TargetLanguageCodes = $AzAiSessionTemp.Bcp47LanguageCodes

                # Return a list of language codes starting with the characters already typed for the parameter.
                $TargetLanguageCodes.where({ $_ -like "$WordToComplete*" })
            })]
        [String]
        $To,

        [Parameter(HelpMessage = "Specify the source language. If ommited language autodetections is applied.")]
        [ArgumentCompleter({
                Param (
                    $Command,
                    $Parameter,
                    $WordToComplete,
                    $CommandAst,
                    $FakeBoundParameters
                )

                # Get the session variable content.
                $AzAiSessionTemp = Get-AzAiSessionSetting

                # Get the list of language codes retrieved from the session variable.
                $TargetLanguageCodes = $AzAiSessionTemp.Bcp47LanguageCodes

                # Return a list of language codes starting with the characters already typed for the parameter.
                $TargetLanguageCodes.where({ $_ -like "$WordToComplete*" })
            })]
        [String]
        $From,

        # All API requests to the Document Translation feature require a custom domain endpoint that is located on your resource overview page in the Azure portal.
        # https://learn.microsoft.com/en-us/azure/ai-services/translator/document-translation/reference/get-supported-document-formats#request-url
        [Parameter(HelpMessage = "Specify the service endpoint to connect to.")]
        [ValidateSet("Custom")]
        [String]
        $ServiceEndpoint = "Custom",

        [Parameter(Mandatory = $false, HelpMessage = "Specifies the subscription key for authentication.")]
        [String]
        $SubsriptionKey = $Script:AzAiSession.Authentication.OcpApimSubscriptionKey,

        [ArgumentCompleter({
                Param (
                    $Command,
                    $Parameter,
                    $WordToComplete,
                    $CommandAst,
                    $FakeBoundParameters
                )

                # Get the session variable content.
                $AzAiSessionTemp = Get-AzAiSessionSetting

                # Get the list of countries retrieved from the session variable.
                $AzureRegions = $AzAiSessionTemp.AzureRegions

                # Return a list of countries starting with the characters already typed for the parameter.
                $AzureRegions.where({ $_ -like "$WordToComplete*" })
            })]
        [Parameter(HelpMessage = "Specify the region of the multi-service or regional translator resource.")]
        [String]
        $SubscriptionRegion = $Script:AzAiSession.SubscriptionRegionToUse,

        [Parameter(HelpMessage = "Specify the API version to use. Version 3.0 is currently the only supported version.")]
        [String]
        $DocumentApiVersion = $Script:AzAiSession.DocumentApiVersion,

        [Parameter(HelpMessage = "Specify that the service is allowed to fall back to a general system when a custom system doesn't exist.")]
        [Switch]
        $AllowFallback,

        [Parameter(HelpMessage = "A string specifying the category (domain) for the translation. This parameter is used to get translations from a customized system built with Custom Translator.")]
        [String]
        $Category,

        [Parameter(HelpMessage = "If specified, overwrites an eventually existing output file.")]
        [Switch]
        $Force
    )

    # Synchronous supported document formats.
    # https://learn.microsoft.com/en-us/azure/ai-services/translator/document-translation/overview#synchronous-supported-document-formats
    # $DocumentTypes = @{
    #     txt   = 'text/plain'
    #     tsv   = 'text/tab-separated-values'
    #     tab   = 'text/tab-separated-values'
    #     csv   = 'text/csv'
    #     html  = 'text/html'
    #     htm   = 'text/html'
    #     mhtml = 'message/rfc822'
    #     mht   = 'message/rfc822'
    #     pptx  = 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
    #     xlsx  = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    #     docx  = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    #     msg   = 'application/vnd.ms-outlook'
    #     xlf   = 'application/xliff+xml'
    #     xliff = 'application/xliff+xml'
    # }
    $DocumentTypes = Get-AzAiSupportedDocumentFormat

    # Synchronous supported glossary formats.
    # https://learn.microsoft.com/en-us/azure/ai-services/translator/document-translation/overview#synchronous-supported-glossary-formats
    # $GlossaryTypes = @{
    #     csv   = 'text/csv'
    #     tsv   = 'text/tab-separated-values'
    #     tab   = 'text/tab-separated-values'
    #     xlf   = 'application/xliff+xml'
    #     xliff = 'application/xliff+xml'
    # }
    $GlossaryTypes = Get-AzAiSupportedGlossaryFormat

    # Throw an error if there is no subscription key.
    if ([string]::IsNullOrEmpty($SubsriptionKey)) {
        throw "No subscription key specified. Specify an subscription key either by using the parameter 'SubscriptionKey' or by setting an subscription key in the session variable with 'Set-AzAiSessionSetting -SubscriptionKey <key>'."
    }

    if ((Test-Path $OutputFile) -and (-not ($Force.IsPresent))) {
        Write-Warning -Message "Output file already exist. Use paramter '-Force' to overwrite it. Cancelling here."
        break
    }

    if ($null -eq ($DocumentTypes.where({ $_.fileExtensions -contains $InputFile.Extension })).contentTypes) {
        throw "Unsupported input file format/file extension: [$($InputFile.Extension)]."
    }
    else {
        Write-Verbose -Message "Setting input file type to [$(($DocumentTypes.where({ $_.fileExtensions -contains $InputFile.Extension })).contentTypes))]."
    }

    # Prepare the form to upload the file and paramters.
    $Form = @{
        document = $InputFile
        type     = ($DocumentTypes.where({ $_.fileExtensions -contains $InputFile.Extension })).contentTypes
    }

    # Add glosary file.
    if ($PSBoundParameters.Keys -contains 'GlossaryFile') {
        # Check the file extension and verify it's in the list of supported file format extensions.
        if ($null -eq ($GlossaryTypes.where({ $_.fileExtensions -contains $GlossaryFile.Extension })).contentTypes) {
            Write-Warning -Message "Unsupported glossary file format/file extension: [$($GlossaryFile.Extension)]. Skipping glossary usage."
        }
        else {
            Write-Verbose -Message "Using glossary file [$($GlossaryFile.FullName)] with file format [$( ($GlossaryTypes.where({ $_.fileExtensions -contains $GlossaryFile.Extension })).contentTypes)]."
            $Form.glossary = $GlossaryFile
            $Form.type = ($GlossaryTypes.where({ $_.fileExtensions -contains $GlossaryFile.Extension })).contentTypes
        }
    }


    # Build Uri string based on all specified parameter values.
    # Prepare the base Uri based on the selected service endpoint.
    $ServiceEndpointUri = Get-AzAiServiceEndpointUri -ServiceEndpoint $ServiceEndpoint
    $Uri = "$($ServiceEndpointUri)translator/document:translate"

    # Add parameter 'targetLanguage' to query string.
    if (-not [string]::IsNullOrEmpty($To)) {
        $Uri = "$($Uri)?targetLanguage=$($To)"
    }

    # Add parameter 'sourceLanguage' to query string in case it was specified.
    if ($PSBoundParameters.Keys -contains 'From') {
        if (-not [string]::IsNullOrEmpty($From)) {
            $Uri = "$($Uri)&sourceLanguage=$($From)"
        }
    }

    # Add parameter 'allowFallback' to query string in case it was specified.
    if ($PSBoundParameters.Keys -contains 'AllowFallback') {
        $Uri = "$($Uri)&allowFallback=$($AllowFallback.IsPresent)"
    }

    # Add parameter 'category' to query string in case it was specified.
    if ($PSBoundParameters.Keys -contains 'Category') {
        if (-not [string]::IsNullOrEmpty($Category)) {
            $Uri = "$($Uri)&category=$($Category)"
        }
    }

    # Finally add parameter 'api-version' to query string.
    $Uri = "$($Uri)&api-version=$DocumentApiVersion"

    $InvokeWebRequestParams = @{
        Uri         = $Uri
        Method      = "Post"
        Headers     = @{
            'Ocp-Apim-Subscription-Key' = $SubsriptionKey
        }
        Form        = $Form
        OutFile     = $OutputFile.FullName
        ErrorAction = "Stop"
    }

    # Check if a specific Azure Region was specified.
    if (-not([string]::IsNullOrEmpty($SubscriptionRegion))) {
        Write-Verbose -Message "Setting request header parameter 'Ocp-Apim-Subscription-Region' to value [$($SubscriptionRegion)]"
        $InvokeWebRequestParams.Headers.'Ocp-Apim-Subscription-Region' = $SubscriptionRegion
    }

    # Check if a value was specified for parameter 'ClientTraceId'.
    if ($PSBoundParameters.Keys -contains 'ClientTraceId') {
        Write-Verbose -Message "Setting request header parameter 'X-ClientTraceId' to value [$ClientTraceId]"
        $InvokeWebRequestParams.Headers.'X-ClientTraceId' = $ClientTraceId
    }

    try {
        if ([string]::IsNullOrEmpty($SubscriptionRegion)) {
            Write-Verbose -Message "No subscription region was specified. If your Azure Translator resource is located in any other region than 'Global', a subscription region is required."
        }
        Write-Verbose -Message "Calling URI [$Uri]."
        Invoke-WebRequest @InvokeWebRequestParams

        Write-Verbose -Message "Output file written: [$($Outputfile.FullName)]."
    }
    catch {
        $_
    }
}
