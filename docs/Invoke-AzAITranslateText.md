---
external help file: AzAiTranslate-help.xml
Module Name: AzAiTranslate
online version: https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Invoke-AzAiTranslateDocument.md
schema: 2.0.0
---

# Invoke-AzAiTranslateDocument

## SYNOPSIS

Translate a single document from one language to another using Azure AI Translator REST API.

## SYNTAX

```
Invoke-AzAiTranslateDocument [-InputFile] <FileInfo> [-OutputFile] <FileInfo> [[-GlossaryFile] <FileInfo>]
 [-To] <String> [[-From] <String>] [[-ServiceEndpoint] <String>] [[-SubsriptionKey] <String>]
 [[-SubscriptionRegion] <String>] [[-DocumentApiVersion] <String>] [-AllowFallback] [[-Category] <String>]
 [-Force] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION

The 'Invoke-AzAiTranslateDocument' translates a single document from one language to another using Azure AI Translator REST API.

## EXAMPLES

### EXAMPLE 1

```PowerShell
Invoke-AzAiTranslateDocument -InputFile C:\Temp\TranslateThis.txt -OutputFile C:\Temp\TranslationResult.txt -From 'en' -To 'de'
```

This will translate the content of 'C:\Temp\TranslateThis.txt' from English to German and save the result in 'C:\Temp\TranslationResult.txt'.

## PARAMETERS

### -AllowFallback

Specify that the service is allowed to fall back to a general system when a custom system doesn't exist

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Category

A string specifying the category (domain) for the translation.
This parameter is used to get translations from a customized system built with Custom Translator.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DocumentApiVersion

The ApiVersion to use for document translation.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: $Script:AzAiSession.DocumentApiVersion
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

If specified, overwrites an eventually existing output file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -From

The source language (for example 'de').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GlossaryFile

The filepath to a glossary file containing customize translations.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputFile

The filepath to the input document to translate.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputFile

The filepath to the output file.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction

{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceEndpoint

The service endpoint to use.
Can by any of "Global", "Americas", "AsiaPacific", "Europe".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Custom
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionRegion

The region of the multi-service or regional translator resource.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: $Script:AzAiSession.SubscriptionRegionToUse
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubsriptionKey

The subscript key (API key) of your Azure AI Translator subscription.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $Script:AzAiSession.Authentication.OcpApimSubscriptionKey
Accept pipeline input: False
Accept wildcard characters: False
```

### -To

The target language (for example 'en').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing

## OUTPUTS

### Nothing

## NOTES

Author:     <diko@admins-little-helper.de>
Email:      <diko@admins-little-helper.de>

## RELATED LINKS

[https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Invoke-AzAiTranslateDocument.md](https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Invoke-AzAiTranslateDocument.md)
