$outDir = "stitch_screens"
if (!(Test-Path -Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

$downloads = @(
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1WwowbvRbkObNSsgpJErTInrOoxe2vzO7aQY12gIKj7kqyhleFtSWGL2lvaO9oAmsOHNWUYSf1b7EYic2sTzyMBw2apkcUqsXhW2bmXCdOeEAxRarZBJAehjSjcYopEi4JG2zbBFMUKxPACok4aZdi_4XE7FlboeisdNLCg-Pd_ZKl59nXd6izgSJtvLxJ2GxvSxrNWIIeTPCQlWyoRptO18aqdaVQ_4emFk_Ub2NOGqCJuIDVZiUNtvYjz"; File = "screen_1.jpg" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1Yzc0MWUxNzllOGQwODlhZjVlNTc0MGE0NmUxEgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "screen_1.html" },
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1URMAuh67DApbxDqfEUkS8xcStBYqFbei9-tgQnpXtIRkRVvW2BGlKGjGtM60WzVfvqQxNqzRpCt30S7pfAuXiJso5m68X-JwSLkBhtD8mhy248Ku618vb2YQc0dkwHetwAg7lCLNN4rXVqJKWc1y9CkVIoDr0Y6wkpj2_yi3kCVDiS6E0T-2sVoNwm1-uusvG_jluQjMB7nPlZlXZE5dZU7PPdqFKS1WZQLENLQjqP-nnQwO2dpkFXMRGV"; File = "screen_2.jpg" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1Yzc0MWUzYTUwOWEwNTc2MzFmZTc0MTA0Y2Y3EgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "screen_2.html" },
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1U_GsHekdPaZOheRvDh7at66iQNRs0hKLd7zWo3MUadNfCOzoSu2PuAtfPNuriE13YLtgZJD6bSDzGzQeKXtQHnt8imY4oKChQcmkVHJY2XeKejZPnhccTJg9Dckf-1r9S-xM2aJhyZzwdXTauZUmhCDH3g5MNOqyinGksHbXRDkJmciu2oUlI1Ozn2Xer3gtGVhI0QmR0akGFJ3JzKbd-kUsAdvaedY_pv_aRPhYXS17JxXygCWdUJbbIL"; File = "screen_3.jpg" },
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1V-8fhEu_GQ4JRPwZ_aZmyTNKRJtIVCMz3e20zQIkTHuugT-jVDIRm9g0OEVKhQiONmNtb0NrZR-qFj3RamejmLEeYEdca_r-GGuPsgq30kkNo7vcK9dWOVpuntwmvGP4Fv69bfgB66HB_d7ecXyDXod-8PYm-2b-1SeIASUATs77b_H1tbJ5xZfRRike6Tfw1yQinmVXNt-u78NJnkHV8Di16ntHhfiqtzZulrhPFpdiSeKQXcAjrqcnwz"; File = "screen_4.jpg" },
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1UzbQ6Xpg8xIHD7DocEKP4Kh3-M2HBQQcoMLqfz79J39_NDRphlFEpSeocW37xxoceia4CQJpRo95AXQ1tLgqj_f0sYEtQ3m7IvvoCOXPJHuF_j8OERTfrKG-Ul5cJrdKi-BQ8fcQ5MVtqFjG1tLKfFZCqhr6RGz-6H_XNxmlskcJwRyjqCqn6kTX24Ul3Kkt846qj94fPFd0LxAVb9x6ovffKfVQ9sgN0mHtDNJx_sopAZuJvQjH79PF8C"; File = "screen_5.jpg" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1Yzc0MWU4NTY3YTgwMjA3OTk0OTY5MDdlMWYwEgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "screen_5.html" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1Yzc0MWQzYWE1ZDAwMjJkN2ViYWQ5MTY1ZjA3EgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "screen_6.html" },
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1Ub8R8B4l7chLU65brC5PI8OrKoIo0_AdhpOPEIckMu0ePtpMnikiwsX_0IfRRLPqj0kxl-9Kb3Rm3UbJ2eLTbqzvxcqPPxFcaWBeEIOObGVM5GnCwsOOmQ-alwLfbE58T7K94D2SxP8eN4kfAXBm0wNNSyEPFClCLcW_MfCgIfi-d4D9fidXDwknIt3EGteX6wNmP6nYpqA7Lfg5Fhxt8SqJOHo5mNbQSNGuUiV8R5E4p2TOgwjQh23-g"; File = "screen_7.jpg" },
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1VDV7AtKRI7w78sGESW1-r3PhnTzI8P6z3r6Vrbnoltk9Txnxg0EDBNrZjJrPt87XuKENyx7Ywo2crr8Ky4uCF2URNR0YSMrLSrry8faIK7QIATXBGV891TEl-5z86HaN7oNvDfFx7ET0Wa6hC8Ec-zCDOyPN6pSdmzbGN2jmD5FuL-zZRXmdDL2nHB-zD3zplkElA7hIKM_4sN-C5pKNFTFjTTk6gW4xndLpRom7lophM3FHtsn7SvXZ0Q"; File = "screen_8.jpg" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1YzY0ODlmYjhmMzQwOTEwNGY4NThhMzA5NGM0EgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "screen_8.html" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1YzY0ODg1NmFiOTcwMjJkN2ViYWQ5MTY1ZjA3EgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "screen_9.html" },
    @{ Url = "https://lh3.googleusercontent.com/aida/AEtjO1UOCVz5vQpq6fhM0IaNBd9zeNwcnjJu7n-tl68sGwtTsagabkxbRuNRuuQOGoXElN7yfn7ss0Ef7qu8U4G5IDlayYplCtEmvBjwKIezuJY2R0DM1X31XfyAeJcrOBvD159sxsmgUFDq07mMs4J4HTNY5iCGkTguRzG0PLmeS3YsWwIl4a9TF7i0sAcIDCuuOPcw-fplIan6mQ80lzUzoUjmoQ7iExwERTZNHWWX6EIixOBfh6BKqO0Rn6EL"; File = "screen_10.jpg" },
    @{ Url = "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ8Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpbCiVodG1sXzAwMDY1YzY0MDM2N2ZhNDYwNTc2MmM4Yjc1MGU4NjhmEgsSBxDdteOjoh0YAZIBJAoKcHJvamVjdF9pZBIWQhQxNzI3Njg0NDM0NTg1OTk4NTAyNg&filename=&opi=89354086"; File = "screen_10.html" }
)

foreach ($dl in $downloads) {
    $filePath = Join-Path $outDir $dl.File
    Write-Host "Downloading $($dl.File)..."
    curl.exe -L -s $dl.Url -o $filePath
}
Write-Host "Done downloading all files."
