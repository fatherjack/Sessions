# PowerShell is all script and command line but what if we want to encourage people 
# who need a UI or we are delivering code to people that have no interest in script?

# start by adding in the WPF GUI frameworks
Add-Type -AssemblyName Presentationframework, presentationcore

# hashtable for GUI
$wpf = @{}

# a description ofour interface, in xml form
$inputXML = Get-Content "C:\Users\Jonathan\Documents\Visual Studio 2017\Projects\GUI01\GUI01\MainWindow.xaml"

$inputXML

$firstItem = $inputXML | select -First 1

$firstItem.GetType()

$CleanedXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N", 'N' -replace 'x:Class=".*?"','' -replace 'd:DesignHeight="\d*?"','' -replace 'd:DesignWidth"\d*?"',''

# test for 'clean' content by trying to convert to xml
[xml]$xaml = $CleanedXML

$reader = New-Object system.xml.xmlnodereader $xaml

# create our window object variable
$tempForm = [windows.markup.xamlreader]::load($reader)

$tempForm.GetType()

$namednodes = $xaml.SelectNodes(("//*[@*[contains(translate(name(.),'n','N'),'Name')]]"))

foreach($node in $namednodes ) {
    $wpf.Add($node.name, $tempform.FindName($node.Name))
}

$wpf.cmdOK.add_click(
    {
        # get values from form
        $Speaker = $wpf.txtSpeaker.Text
        $Session = $wpf.txtSession.Text
     
        # set values on form
        switch ($Speaker)
        {
            'Jonathan' {
                $wpf.imgSpeakerIamge.Source = "C:\Users\Jonathan\OneDrive\Pictures\MUG_s_400x400.jpg" 
            }
            'Mark' {
                $wpf.imgSpeakerIamge.Source = "C:\Users\Jonathan\OneDrive\Pictures\MPM.jpg" 
            }
            Default {
                $wpf.imgSpeakerIamge.Source = "C:\Users\Jonathan\OneDrive\Pictures\beeimage.jpg" 
            }
        }
    }
)

# Show the form for the user to provide input
$wpf.WindowEvent.ShowDialog() | out-null

# Accessing the values provided in the form ...
Write-Output ("The user entered Speaker name {0} and Session title {1}" -f $Speaker, $Session)