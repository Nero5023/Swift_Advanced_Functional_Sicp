class Solution(object):
    def reverse(self, x):
        """
        :type x: int
        :rtype: int
        """
        reversed = 0
        sign = -1 if x < 0 else 1
        x = abs(x)
        while x!=0:
            print (reversed*10+x%10)
            reversed = (reversed*10+x%10)
            x/=10
            # print reversed
        if reversed < -(1 << 31) or reversed > (1 << 31) - 1:
            return 0
        return reversed*sign


        #  while (n != 0) {
        #     int temp = reversed_n * 10 + n % 10;
        #     n = n / 10;
        #     if (temp / 10 != reversed_n) {
        #         reversed_n = 0;
        #         break;
        #     }
        #     reversed_n = temp;
        # }

if __name__ == '__main__':
    Solution().reverse(-123)