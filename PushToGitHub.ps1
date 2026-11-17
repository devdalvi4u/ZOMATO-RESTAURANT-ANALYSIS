$ErrorActionPreference = "Stop"

Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host " Train Sim Consist Builder - Automated Git Commit & Push" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan

# 1. Check for changes
$status = git status --porcelain
if (-not $status) {
    Write-Host "`nNo changes detected to commit. Working tree is clean." -ForegroundColor Yellow
    exit 0
}

Write-Host "`nChanged / Modified Files:" -ForegroundColor Yellow
git status --short

# 2. Directly ask for commit message input
Write-Host ""
$CommitMessage = Read-Host "Enter Commit Message"

while ([string]::IsNullOrWhiteSpace($CommitMessage)) {
    Write-Host "Commit message cannot be empty!" -ForegroundColor Red
    $CommitMessage = Read-Host "Enter Commit Message (or press Ctrl+C to cancel)"
}

try {
    Write-Host "`n[1/3] Staging changes..." -ForegroundColor Green
    git add .

    Write-Host "[2/3] Committing changes with message: '$CommitMessage'..." -ForegroundColor Green
    git commit -m "$CommitMessage"

    $branch = (git branch --show-current).Trim()
    if (-not $branch) { $branch = "main" }

    Write-Host "[3/3] Pushing to GitHub (origin/$branch)..." -ForegroundColor Green
    git push origin $branch

    Write-Host "`n=====================================================================" -ForegroundColor Green
    Write-Host " Successfully pushed changes to GitHub ($branch)!" -ForegroundColor Green
    Write-Host "=====================================================================" -ForegroundColor Green
}
catch {
    Write-Host "`nError during Git push operation:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
