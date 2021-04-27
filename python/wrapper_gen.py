def iter1(item):
    return item[1]

def iter0(item):
    return sum(item[0])

def applyFlexible(combo, number):
    comboLengths = []
    for pair in combo:
        comboLengths.append((pair, sum(pair)))
    

    while number:
        comboLengths.sort(key=iter1)
        diff = comboLengths[-1][1] - comboLengths[0][1]

        toAdd = max(min(number, diff), 1)
        newLength = toAdd + comboLengths[0][1]

        comboLengths[0] = (comboLengths[0][0], newLength)
        number -= toAdd
    
    ret = [(combo, length - sum(combo)) for combo, length in comboLengths ]
    ret.sort(key=iter1)
    ret.sort(key=iter0)
    return ret

def getCombos(chains, width):
    ret = []
    pairLength = max(int(len(chains) / width), 1)
    getRemainingCombos([], chains, width, ret, pairLength)
    ret.sort(key=max)
    return ret[0]

def partitionList(parent, width, remaining, pairLength):
    ret = []
    remaining = remaining[:]

    for index in range(width):
        ret.append(parent[index*pairLength:(1 + index)*pairLength])

    if remaining:
        remaining.sort(reverse=True)

    while remaining:
        ret.sort(key=sum)
        ret[0].append(remaining.pop(0))

    for pair in ret:
        pair.sort()

    return ret

def getRemainingCombos(parent, remaining, width, comboList, pairLength):
    
    if not remaining or len(remaining) < width:
        partitionedList = partitionList(parent, width, remaining, pairLength)
        partitionedList.sort(key=sum)

        if partitionedList not in comboList:
            comboList.append(partitionedList)
        return
        
    
    left = remaining[:]

    for chain in left:
        toDo = left[:]
        toDo.remove(chain)

        currentCombo = parent[:]
        currentCombo.append(chain)

        getRemainingCombos(currentCombo, toDo, width, comboList, pairLength)

def printAsTable(inputs, outputs, width):

    header = ["Wrapper Scan Chain"]
    scanChains = ["Internal Scan Chains ([scan chains], length)"]
    inputCells = ["Wrapper Input Cells"]
    outputCells = ["Wrapper Output Cells"]
    scanLengths = ["Scan-in, Scan-out Length (in, out)"]

    for index in range(len(inputs)):
        header.append(index + 1)
        internalLength = sum(inputs[index][0])
        scanChains.append((inputs[index][0], internalLength))
        inputCells.append(inputs[index][1])
        outputCells.append(outputs[index][1])
        scanLengths.append((internalLength + inputs[index][1], internalLength + outputs[index][1]))

    print("\\begin{table}[H]\n\\centering\n\\begin{tabular}", end="")
    print("{", "|l|", *(["c|"]*len(inputs)) , "} \\hline")
    printRow(header)
    printRow(scanChains)
    printRow(inputCells)
    printRow(outputCells)
    printRow(scanLengths)
    print("\\end{tabular}\n\\caption{Wrapper for TAM Width of %d}\n\\end{table}" % width)

def printRow(list):
    toPrint = [""]
    print(*list, sep=" & ", end=" \\\\ \\hline\n")






