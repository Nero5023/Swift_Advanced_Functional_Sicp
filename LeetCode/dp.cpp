//
//  main.cpp
//  dp
//
//  Created by Nero Zuo on 16/11/22.
//  Copyright © 2016年 Nero. All rights reserved.
//

#include <iostream>
#include <vector>

using namespace std;

const int MAX_SUM = 100000;
bool arr[MAX_SUM];

int sumv(vector<int> &v, int end) {
  int sum = 0;
  for (int i = 0; i<=end; i++) {
    sum += v[i];
  }
  return sum;
}

int solve_by_dp(vector<int> &v, int sum) {
  fill(arr, arr+MAX_SUM, false);
  arr[0] = true;
  for (int i= 0; i<v.size(); i++) {
    int sum = sumv(v, i);
    for (int j= v[i]; j<=sum; j++) {
      if (arr[j-v[i]])
        arr[j] = true;
    }
  }
  int mid = sum/2;
  for (int i=0; i<=mid; i++) {
    int one = mid-i;
    if (arr[one]) {
      int other = sum - one;
      return other>one? other-one : one-other;
    }
  }
  return -1;  // never been here
}

#include <stdio.h>
#include <iostream>
#include <vector>
using namespace std;


int minCoins(vector<int> &coins, int total) {
  int minc[1000];
  fill(minc, minc+1000, 100000);
  int coinsCount = coins.size();
  minc[0] = 0;
  for (int i = 1; i <= total; ++i)
  {
    for (int j = 0; j < coinsCount; ++j)
    {
      if (coins[j] <= i && minc[i-coins[j]]+1 < minc[i])
      {
        minc[i] = minc[i-coins[j]]+1;
      }
    }
  }
  return minc[total];
}


//int main() {
//  int temp[] = {1,3,5};
//  vector<int> vc(temp, temp+3);
//  cout << minCoins(vc, 11) << endl;
//}

int lis2(int nums[], int count) {
  int *longest = new int[count];
  for (int len = 0; len < count; ++len){
    longest[len] = 1;
    for (int i = 0; i < len; ++i){
      if (nums[len] > nums[i] && longest[i]+1 > longest[len]){
        longest[len] = longest[i] + 1;
      }
    }
  }
  int result = longest[count-1];
  cout << result << endl;
  delete[] longest;
  return result;
}
int main(){
  int A[] = {
    5, 3, 4, 8, 6, 7
  };
  cout<<lis2(A, 6)<<endl;
  return 0;
}


