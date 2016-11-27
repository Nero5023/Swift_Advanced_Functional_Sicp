#include <stdio.h>
#include <iostream>
#include <vector>
using namespace std;

int minc[1000];

int minCoins(vector<int> &coins, int total) {
    fill(minc, minc+1000, 100000);
    int coinsCount = coins.size();
    minc[0] = 0;
    for (int i = 1; i <= total; ++i)
    {
        for (int j = 0; j < coinsCount; ++j)
        {
            int minCount = 100000;
            if (coins[j] <= i){
                int count = minc[i-coins[j]] + 1;
                if (minCount > count) {
                    minc[i] = count;
                }
            }
        }
    }
    return minc[total];
}

int minCoinsRec(vector<int> &coins, int total, int count) {
    if (total == 0)
    {
        return count;
    }
    if (total < 0)
    {
        return 1000000;
    }
    int min = 1000000;
    for(int i = 0; i < coins.size(); ++i) {
        int temp = minCoinsRec(coins, total - coins[i], count+1);
        if (min > temp)
        {
            min = temp;
        }
    }
    return min;
}


int main() {
    int temp[] = {1,3,5};
    vector<int> vc(temp, temp+3);
    cout << minCoinsRec(vc, 11, 0) << endl;
}