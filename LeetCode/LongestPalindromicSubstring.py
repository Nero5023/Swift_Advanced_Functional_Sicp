def longestPalindromicSubstring(str):
    maxLength = 0
    maxStr = ""
    for starIndex in xrange(0,len(str)-1):
        for endInex in xrange(starIndex+1,len(str)):
            if isPalindromic(str[starIndex:endInex]):
                if (endInex-starIndex)>maxLength:
                    maxLength = endInex - starIndex
                    maxStr = str[starIndex:endInex]
    return maxStr






def isPalindromic(str):
    return reverse(str) == str

def reverse(str):
    return str[::-1]


def longestPalindromicSubstringDP(str):
        length = len(str)
        table = [[False]*length for row in range(length)]
        logestStartIndex = 0
        maxLength = 1
        for i in xrange(0, length):
            table[i][i] = True
        for i in xrange(0, length-1):
            if str[i] == str[i+1]:
                table[i][i+1] = True
                logestStartIndex = i
                maxLength = 2
        for checkLen in xrange(3, length+1):
            for starIndex in xrange(0, length - checkLen + 1):
                endInex = starIndex + checkLen - 1;
                if str[starIndex] == str[endInex] and table[starIndex+1][endInex-1]:
                    table[starIndex][endInex] = True
                    logestStartIndex = starIndex
                    maxLength = checkLen
        return str[logestStartIndex: logestStartIndex+maxLength]


if __name__ == '__main__':
    print longestPalindromicSubstringDP("civilwartestingwhetherthatnaptionoranynartionsoconceivedandsodedicatedcanlongendureWeareqmetonagreatbattlefiemldoftzhatwarWehavecometodedicpateaportionofthatfieldasafinalrestingplaceforthosewhoheregavetheirlivesthatthatnationmightliveItisaltogetherfangandproperthatweshoulddothisButinalargersensewecannotdedicatewecannotconsecratewecannothallowthisgroundThebravelmenlivinganddeadwhostruggledherehaveconsecrateditfaraboveourpoorponwertoaddordetractTgheworldadswfilllittlenotlenorlongrememberwhatwesayherebutitcanneverforgetwhattheydidhereItisforusthelivingrathertobededicatedheretotheulnfinishedworkwhichtheywhofoughtherehavethusfarsonoblyadvancedItisratherforustobeherededicatedtothegreattdafskremainingbeforeusthatfromthesehonoreddeadwetakeincreaseddevotiontothatcauseforwhichtheygavethelastpfullmeasureofdevotionthatweherehighlyresolvethatthesedeadshallnothavediedinvainthatthisnationunsderGodshallhaveanewbirthoffreedomandthatgovernmentofthepeoplebythepeopleforthepeopleshallnotperishfromtheearth")