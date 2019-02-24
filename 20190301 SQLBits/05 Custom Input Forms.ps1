# PowerShell is all script and command line but what if we want to encourage people 
# who need a UI or we are delivering code to people that have no interest in script?

# start by adding in the WPF GUI frameworks
Add-Type -AssemblyName Presentationframework, presentationcore

# hashtable for GUI
$wpf = @{}

# a description of our interface, in xml form
$inputXML = Get-Content "C:\Users\Jonathan\Documents\Visual Studio 2017\Projects\GUI01\GUI01\MainWindow.xaml"

$inputXML

# where can we create all this?
#Invoke-Item "C:\Users\Jonathan\Documents\Visual Studio 2017\Projects\GUI01\GUI01.sln"

$firstItem = $inputXML | select -First 1

[xml]$CleanedXML = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace 'x:Class=".*?"', '' -replace 'd:DesignHeight="\d*?"', '' -replace 'd:DesignWidth"\d*?"', ''

$reader = New-Object system.xml.xmlnodereader  $CleanedXML

# create our window object variable
$tempForm = [windows.markup.xamlreader]::load($reader)

$tempForm.GetType()

$namednodes = $CleanedXML.SelectNodes(("//*[@*[contains(translate(name(.),'n','N'),'Name')]]"))

# place every named object into our $wpf hashtable
foreach ($node in $namednodes ) {
    $wpf.Add($node.name, $tempform.FindName($node.Name))
}

# add logic to be executed when a control event takes place. Here we are using the add_clikc method to add a click event to the cmdCheck button
$wpf.cmdCheck.add_click(
    {
        # get values from form
        $script:speaker = $Speaker = $wpf.txtSpeaker.Text
        $script:session = $Session = $wpf.txtSession.Text
     
        # set values on form
        switch ($Speaker) {
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






# yes, I know there is a spelling mistake in the image control name. thanks for paying attention though :)