def solve_by_force(coins, cursor, end, soFar, sum):
    if cursor == end:
        other = sum - soFar
        return abs(other-soFar)
    choose = solve_by_force(coins, cursor+1, end, soFar+coins[cursor], sum)
    unChoose = solve_by_force(coins, cursor+1, end, soFar, sum)
    if choose > unChoose:
        return unChoose
    else:
        return choose

if __name__ == '__main__':
    coins = [10, 23, 43, 32, 54, 65, 75, 86, 23, 43, 12, 43, 63]
    print solve_by_force(coins, 0, len(coins)-1, 0, sum(coins))