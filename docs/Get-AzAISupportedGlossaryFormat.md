---
external help file: AzAiTranslate-help.xml
Module Name: AzAiTranslate
online version: https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Get-AzAiSupportedGlossaryFormat.md
schema: 2.0.0
---

# Get-AzAiSupportedGlossaryFormat

## SYNOPSIS

Returns a list of glossary formats supported for document translation.

## SYNTAX

```
Get-AzAiSupportedGlossaryFormat [[-ServiceEndpoint] <String>] [[-SubsriptionKey] <String>]
 [[-SubscriptionRegion] <String>] [[-DocumentApiVersion] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION

The 'Get-AzAiSupportedGlossaryFormat' returns a list of glossary formats supported for document translation.

## EXAMPLES

### EXAMPLE 1

```PowerShell
Get-AzAiSupportedGlossaryFormat
```

Returns a list of glossary formats supported for document translation.

## PARAMETERS

### -DocumentApiVersion

The ApiVersion to use for document translation.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:AzAiSession.DocumentApiVersion
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
Can by any of "Global", "Americas", "AsiaPacific", "Europe", "Custom".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Position: 3
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
Position: 2
Default value: $Script:AzAiSession.Authentication.OcpApimSubscriptionKey
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

[https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Get-AzAiSupportedGlossaryFormat.md](https://github.com/admins-little-helper/AzAiTranslate/blob/main/Help/Get-AzAiSupportedGlossaryFormat.md)
