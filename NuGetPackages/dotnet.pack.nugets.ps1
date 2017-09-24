$MsBuild = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\msbuild.exe"

$SolutionFile = Get-ChildItem ..\src -Recurse | Where-Object {$_.Extension -eq ".sln"}
nuget restore $SolutionFile.FullName

foreach ($NugetSpec in Get-ChildItem ..\src -Recurse | Where-Object {$_.Extension -eq ".nuspec"})
{
    $ProjectFile = Get-ChildItem $NugetSpec.DirectoryName | Where-Object {$_.Extension -eq ".csproj"}

    $BuildArgs = @{
        FilePath = $MsBuild
        ArgumentList = $ProjectFile.FullName,  "/p:Configuration=Release /t:Rebuild"
        Wait = $true
    }
    
    Start-Process @BuildArgs -NoNewWindow
    dotnet pack $ProjectFile.FullName -c Release --no-build -o $pwd /p:Version=2.0
}