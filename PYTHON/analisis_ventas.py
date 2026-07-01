#---------------------------------------------------------
#DÍA 1- IMPORTAR BASE DE DATOS Y PRIMERA VISTA
#---------------------------------------------------------
import pandas as pd #antes he puesto en la terminal pip install pandas
ventas= pd.read_csv("ventas.csv") #open folder y eliges exactamente la carpeta donde se encuentran los archivos
print(ventas.head()) 
print(ventas.info())
print(ventas.describe())
print(ventas.isna().sum())


#---------------------------------------------------------
#DIA 2- LIMPIEZA DE DATOS Y CREACION COLUMNAS
#---------------------------------------------------------
import pandas as pd
ventas = pd.read_csv("ventas.csv")
ventas = ventas.drop_duplicates() ##limpia duplicados de la tabla
ventas['fecha'] = pd.to_datetime(ventas['fecha']) #para que no los tome como palabras, si no como fecha
ventas['importe'] = ventas['unidades'] * ventas['precio_unitario'] ##crear una columna de importe
print(ventas[['unidades', 'precio_unitario', 'importe']].head()) #comprobamos que sale importe
ventas.to_csv("ventas_limpio.csv", index=False) #nuevo csv con la limpieza y la columna
print(ventas.head) #aunque en el ordenador lo crees como ventas limpio, aqui sigue siendo ventas


#---------------------------------------------------------
#DIA 3- ANALISIS CON GROUP BY
#---------------------------------------------------------

print(ventas.groupby("producto") ["importe"].sum().sort_values(ascending=False)) ##ordenado por producto
print(ventas.groupby("ciudad") ["importe"].sum().sort_values(ascending=False))
print(ventas.groupby("categoria") ["importe"].sum().sort_values(ascending=False))
##para hacerlo por mes, hago antes paso previo para olvidarme de los dias, y creo una nueva columna que se llame mes
ventas['mes'] = ventas['fecha'].dt.to_period('M')
print(ventas.groupby("mes") ["importe"].sum().sort_values(ascending=False))


#---------------------------------------------------------
#DIA 4- GRÁFICOS PARA VISUALIZAR RESULTADOS
#---------------------------------------------------------
import matplotlib.pyplot as plt
resumen_producto = ventas.groupby("producto")["importe"].sum().sort_values(ascending=False) #codigo utilizado ya, pero dandole un nombre
resumen_producto.plot(kind='bar', color='skyblue') #nos crea el grafico de barras sobre los productos en color azul 
plt.tight_layout() #se ajusta el diseño para no cortar los nombres
plt.savefig('facturacion_producto.png') #guardamos el gráfico
plt.show()
plt.clf() #para borrar el gráfico para el siguiente gráfico

resumen_ciudad=ventas.groupby("ciudad")["importe"].sum().sort_values(ascending=False)
resumen_ciudad.plot(kind="bar",color="skyblue")
plt.tight_layout()
plt.savefig("facturacion_ciudad.png")
plt.show()
plt.clf()