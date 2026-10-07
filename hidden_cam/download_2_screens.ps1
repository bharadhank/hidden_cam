$outDir = "stitch_screens"
if (!(Test-Path -Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

$downloads = @(
    # Screen 1 - Onboarding (Your privacy matters)
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1V8xhIJ9zvpjt0XpMAB5tNK_GeOsnnV11N7ycuNIsXfaRLawV-nAvd8qLvnUtWz85VQaIUL7ffWO6JYygSIw5Oc2ig5ResXXMDx8Ayi_Uefu4n-IDJ4aFDbBof6zIOZ8EuTecxzIZsJS_PMsh89X3Q8TMvv2wPlfXgdA-gWInJUjDNdligM4dzpqfZv9wJlexaKVTscHFNgLcry7vPNcVGzvzHT85Znv8qoSFbl5lADDUQWnqXA45WMhqtU"; File = "safelens_onboarding_privacy.jpg" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1Y2ZkZTcxMmI0N2QwMjA3YTkwYzEwMWEwNDA5EgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "safelens_onboarding_privacy.html" },
    # Screen 2 - Onboarding (Check with confidence)
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1XT-r690-KWY6f1aNdFX4tFSctxvoJgdkREI7w9wilnDdcJmqPOXNCdE9ZRcVl2u9SCrVOi5d718exvFSJOFPGWyrORIsC2gDHj5rjx3V8XRpxjEi7pPCaYjchTZajgDv0dJt8vlUnDqPjLu3bzrflWsb1zGdzOkp6vkCRBKT19oUTl5Ca5MDXqZXYcowMj3InkgQa0TwYAK-kmOatfWwaFvdXVq1akgX2ryt_lsrzFwavHydrHyOu7JOSk"; File = "safelens_onboarding_confidence.jpg" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1Y2ZkZTcwMjUxNzYwODQwZDBkODI1MzM3NmJhEgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "safelens_onboarding_confidence.html" }
)

foreach ($dl in $downloads) {
    $filePath = Join-Path $outDir $dl.File
    Write-Host "Downloading $($dl.File)..."
    curl.exe -L -s $dl.Url -o $filePath
}
Write-Host "Done downloading all 2 additional screens."
