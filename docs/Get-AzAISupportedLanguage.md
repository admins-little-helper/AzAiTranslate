---
external help file: AzAiTranslate-help.xml
Module Name: AzAiTranslate
online version: https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Get-AzAiSupportedLanguage.md
schema: 2.0.0
---

# Get-AzAiSupportedLanguage

## SYNOPSIS

Returns a list of languages supported by the Azure AI Translator REST API for text translation.

## SYNTAX

```
Get-AzAiSupportedLanguage [[-Scope] <String[]>] [[-AcceptLanguage] <String>] [[-ServiceEndpoint] <String>]
 [[-AzureRegion] <String>] [[-TextApiVersion] <String>] [[-ClientTraceId] <Guid>] [-ReturnRawResult]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION

The 'Get-AzAiSupportedLanguage' returns a list of languages supported by the Azure AI Translator REST API for text translation.

## EXAMPLES

### EXAMPLE 1

```PowerShell
Get-AzAiSupportedLanguage
```

Returns a list of languages supported by the Azure AI Translator REST API for text translation.

## PARAMETERS

### -AcceptLanguage

The language to use for user interface strings.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AzureRegion

Specify the Azure Region to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:AzAiSession.SubscriptionRegionToUse
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientTraceId

A client-generated GUID to uniquely identify the request.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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

### -ReturnRawResult

If specified, the returned value includes the unmodified query result from the REST api call.

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

### -Scope

A comma-separated list of names defining the group of languages to return.
Allowed group names are: translation, transliteration, and dictionary.
If no scope is given, then all groups are returned

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceEndpoint

The service endpoint to use.
Can by any of "Global", "Americas", "AsiaPacific", "Europe", "Custom".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Scripts:AzAiSession.ServiceEndpointToUse
Accept pipeline input: False
Accept wildcard characters: False
```

### -TextApiVersion

The ApiVersion to use for text translation.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Script:AzAiSession.TextApiVersion
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing

## OUTPUTS

### PSCustomObject

## NOTES

Author:     <diko@admins-little-helper.de>
Email:      <diko@admins-little-helper.de>

## RELATED LINKS

[https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Get-AzAiSupportedLanguage.md](https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Get-AzAiSupportedLanguage.md)
