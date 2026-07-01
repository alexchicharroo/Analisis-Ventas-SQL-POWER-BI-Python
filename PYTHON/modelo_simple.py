import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error

ventas = pd.read_csv('ventas_limpio.csv')
X = ventas[['unidades','precio_unitario']]
y = ventas['importe']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.30, random_state=42)
modelo = LinearRegression()
modelo.fit(X_train, y_train)
pred = modelo.predict(X_test)
print('MAE:', mean_absolute_error(y_test, pred))
print(pd.DataFrame({'real': y_test.head(10).values, 'pred': pred[:10]}))
