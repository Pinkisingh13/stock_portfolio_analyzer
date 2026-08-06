import numpy as np

matrix = np.array([
  [0,0,0], 
  [1,1,1], 
  [2,4,8]
  ] )
print(matrix)
print(np.zeros(5)) 
days = np.arange(1,6)
print(days)


# prices = np.linspace(10,20, 5)
# print(prices)


prices = np.array([2,4,6,8,10,12])


doubled = prices * 2
print(doubled)

percentage = (prices / 100) + 100

print(percentage)


sumofall = np.sum(prices)
print(sumofall)

meanofall = np.mean(prices)
print(meanofall)

std = np.std(prices)
print(std)

returns = (prices[1:] - prices[:-1]) / prices[:-1] * 100
print(returns)

