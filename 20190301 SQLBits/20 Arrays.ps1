# referencing arrays by index

$array = @('cat', 'dog', 'horse', 'sheep', 'zebra')

# everything
$array
# first element
$array[0]
# third element
$array[2]
# last element
$array[4]

# looking at ranges
(2..5)

# last element
$array[-1]

# from second to last element ?
$array[1..-1]

$array[1.. $array.GetUpperBound(0)]
