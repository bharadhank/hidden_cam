$outDir = "stitch_screens"
if (!(Test-Path -Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

$downloads = @(
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1WwowbvRbkObNSsgpJErTInrOoxe2vzO7aQY12gIKj7kqyhleFtSWGL2lvaO9oAmsOHNWUYSf1b7EYic2sTzyMBw2apkcUqsXhW2bmXCdOeEAxRarZBJAehjSjcYopEi4JG2zbBFMUKxPACok4aZdi_4XE7FlboeisdNLCg-Pd_ZKl59nXd6izgSJtvLxJ2GxvSxrNWIIeTPCQlWyoRptO18aqdaVQ_4emFk_Ub2NOGqCJuIDVZiUNtvYjz"; File = "safelens_active_sweep.jpg" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1Yzc0MWUxNzllOGQwODlhZjVlNTc0MGE0NmUxEgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "safelens_active_sweep.html" },
    
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1URMAuh67DApbxDqfEUkS8xcStBYqFbei9-tgQnpXtIRkRVvW2BGlKGjGtM60WzVfvqQxNqzRpCt30S7pfAuXiJso5m68X-JwSLkBhtD8mhy248Ku618vb2YQc0dkwHetwAg7lCLNN4rXVqJKWc1y9CkVIoDr0Y6wkpj2_yi3kCVDiS6E0T-2sVoNwm1-uusvG_jluQjMB7nPlZlXZE5dZU7PPdqFKS1WZQLENLQjqP-nnQwO2dpkFXMRGV"; File = "safelens_home_hub.jpg" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1Yzc0MWUzYTUwOWEwNTc2MzFmZTc0MTA0Y2Y3EgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "safelens_home_hub.html" },
    
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1UzbQ6Xpg8xIHD7DocEKP4Kh3-M2HBQQcoMLqfz79J39_NDRphlFEpSeocW37xxoceia4CQJpRo95AXQ1tLgqj_f0sYEtQ3m7IvvoCOXPJHuF_j8OERTfrKG-Ul5cJrdKi-BQ8fcQ5MVtqFjG1tLKfFZCqhr6RGz-6H_XNxmlskcJwRyjqCqn6kTX24Ul3Kkt846qj94fPFd0LxAVb9x6ovffKfVQ9sgN0mHtDNJx_sopAZuJvQjH79PF8C"; File = "safelens_verification_anime.jpg" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1Yzc0MWU4NTY3YTgwMjA3OTk0OTY5MDdlMWYwEgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "safelens_verification_anime.html" },
    
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1VDV7AtKRI7w78sGESW1-r3PhnTzI8P6z3r6Vrbnoltk9Txnxg0EDBNrZjJrPt87XuKENyx7Ywo2crr8Ky4uCF2URNR0YSMrLSrry8faIK7QIATXBGV891TEl-5z86HaN7oNvDfFx7ET0Wa6hC8Ec-zCDOyPN6pSdmzbGN2jmD5FuL-zZRXmdDL2nHB-zD3zplkElA7hIKM_4sN-C5pKNFTFjTTk6gW4xndLpRom7lophM3FHtsn7SvXZ0Q"; File = "safelens_verification_3d.jpg" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1YzY0ODlmYjhmMzQwOTEwNGY4NThhMzA5NGM0EgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "safelens_verification_3d.html" }
)

foreach ($dl in $downloads) {
    $filePath = Join-Path $outDir $dl.File
    Write-Host "Downloading $($dl.File)..."
    curl.exe -L -s $dl.Url -o $filePath
}
Write-Host "Done downloading SafeLens screens."
