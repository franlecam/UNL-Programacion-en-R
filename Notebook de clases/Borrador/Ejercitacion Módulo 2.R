# Ejercicios Módulo 2 ------------------------------------------------------------------------

# Multiplicadores

# Ejercicio 1 

# Multiplicadores simples

Z <- matrix(c(3, 8, 6, 2, 4, 5, 7, 3, 9), ncol = 3, byrow = TRUE)

x <- c(22, 18, 31)  

hc <- c(2, 3, 5) #Flujo de dinero de los hogares a los sectores productivos por compras

hr <- c(4, 1, 5) #Flujo de dinero de los sectores productivos a los hogares por salarios

INS <- c(1, 2, 1)

inv_x <- solve(diag(x))

A <- Z %*% inv_x

I <- diag(3)

L <- solve(I - A)

i <- rep(1, 3)

mo <- i %*% L

f <- x - rowSums(Z) 

VA <- x - colSums(Z) - INS

vc <- VA / x

vc[ x == 0] <- 0

mva <- vc %*% L

# Multiplicadores totales

Z_b <- matrix(c(3, 8, 6, 2, 2, 4, 5, 3, 7, 3, 9, 5, 4, 1, 5, 3), ncol = 4, byrow = TRUE) #Una forma

Z_b <- rbind(Z, hr) #Otra forma
Z_b <- cbind(Z_b, hc)
Z_b[4, 4] <- 3 #Flujo de dinero de los horares a los hogares por servicios de trabajo

x_b <- c(22, 18, 31, 20)

INS_b <- c(1, 2, 1, 2)

inv_x_b <- solve(diag(x_b))

A_b <- Z_b %*% inv_x_b

I_b <- diag(4)

L_b <- solve(I_b - A_b)

i <- rep(1, 4)

mot <- i %*% L_b

VA_b <- x_b - colSums(Z_b) - INS_b

vc_b <- VA_b / x_b

mvat <- vc_b %*% L_b

# Ejercicio 2 

# Simples

Z <- matrix(c(500, 350, 320, 360), ncol = 2 , byrow = TRUE)

f <- c(1000, 800)

x <- rowSums(Z) + f

inv_x <- solve(diag(x))

A <- Z %*% inv_x

I <- diag(2)

L <- solve(I - A)

m <- c(50, 15)

hr <- c(100, 60)

hc <- c(90, 50)

m_c <- m / x
hr_c <- hr / x

mm <- m_c %*% L
prom_mm <- rowSums(mm) / 2

mh <- hr_c %*% L #Impacto sobre el ingreso salarial originado en un cambio unitario de la demanda final

# Totales

Z_t <- matrix(c(500, 350, 90, 320, 360, 50, 100, 60, 40), ncol = 3, byrow = TRUE)

f_t <- c(910, 750, 300)

x_t <- rowSums(Z_t) + f_t

inv_x_t <- solve(diag(x_t))

A_t <- Z_t %*% inv_x_t

I <- diag(3)

L_t <- solve(I - A_t)

m_t <- c(50, 15, 30)

hr_t <- c(100, 60, 40)

mc_t <- m_t / x_t 

hrc_t <- hr_t / x_t

mm_t <- mc_t %*% L_t
mh_t <- hrc_t %*% L_t

# Ejercicio 3

# MIP Cordoba ---------------------------------------------------------------------------------

# Datos

MIP_Cordoba <- readxl::read_excel("C:/Users/Usuario/Documents/Facultad/Capacitacion MIP Entre Rios/MIP Córdoba/MIP Córdoba Final.xlsx")
Empleo_Ingresos <- readxl::read_excel("C:/Users/Usuario/Documents/Facultad/Capacitacion MIP Entre Rios/MIP Córdoba/Empleo e Ingresos Final.xlsx")

Z <- as.matrix(MIP_Cordoba[1:16, 2:17])
m <- as.matrix(MIP_Cordoba[17, 2:17])
IMS <- as.matrix(MIP_Cordoba[18, 2:17])
VA <- as.matrix(MIP_Cordoba[19, 2:17])
DF <- as.matrix(MIP_Cordoba[1:16, 18:20])
r <-  as.matrix(Empleo_Ingresos[2, 2:17])
e <-  as.matrix(Empleo_Ingresos[1, 2:17])

X <- rowSums(Z) + rowSums(DF)

# Obtener: Multiplicadores simples de producto, empleo, ingreso, importaciones y valor agregado.

# Resultados

inv_x <- solve(diag(X))

A <- Z %*% inv_x

I <- diag(16)

L <- solve(I - A)

i <- rep(1, 16)

Mp <- i %*% L # Multiplicadores de producto

colnames(Mp) <- colnames(Z)

ec <- e / X

ec[X == 0] <- 0

Me <- ec %*% L # Multiplicadores de empleo

colnames(Me) <- colnames(Z)

rc <- r / X

rc[X == 0] <- 0

Mr <- rc %*% L # Multiplicadores de ingreso

colnames(Mr) <- colnames(Z)

mc <- m / X

mc[X == 0] <- 0

Mm <- mc %*% L # Multiplicadores de importaciones

colnames(Mm) <- colnames(Z)

vc <- VA / X

vc[X == 0] <- 0

Mva <- vc %*% L # Multiplicadores de valor agregado

colnames(Mva) <- colnames(Z)

