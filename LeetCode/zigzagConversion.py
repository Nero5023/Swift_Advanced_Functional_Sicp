    def convert(self, s, numRows):
        if numRows == 1:
            return s
        strings = [""]*numRows
        cycle = numRows*2-2
        for i in xrange(0,len(s)):
            beyond = i % cycle
            row = 0
            if beyond < numRows:
                row = beyond
            else:
                row = cycle-beyond
            strings[row]+=s[i]
        str = ""
        for string in strings:
            str+=string
        return str

if __name__ == '__main__':
    print convert(1, "A", 1)