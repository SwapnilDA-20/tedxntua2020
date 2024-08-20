{{/*
Return the name of the chart with the release name
*/}}
{{- define "tedx2020.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the name of the chart
*/}}
{{- define "tedx2020.name" -}}
{{- .Chart.Name -}}
{{- end -}}

