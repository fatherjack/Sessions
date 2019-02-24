# referencing arrays by index

$array = @('cat', 'dog', 'horse', 'sheep', 'zebra')

# what type do we get?
$array | Get-Member

$array.GetType()

# show everything
$array
# show first element
$array[0]
# show third element - its zero-based index
$array[2]
# last element
$array[4] # always the 5th element

$array[-1] # always the last element

# looking at ranges
# Powershell can give us a series of integers when we specify 
(2..5)
(5..2)
(5..-5)

# last element
$array[-1]

# from second to last element ?
$array[1..-1] # oops

$array[1.. $array.GetUpperBound(0)]
