###############
## 단순 계산 ##
###############
1-2*3

4*(2+7)

100/5

3^3+1

sqrt(10)

# 논리 연산자

2*3 == 6

1310 >= 26359/20

24/90 != 8/30

##############################
## 변수(객체)에 값 할당하기 ##
##############################
x <- 1:4
x

x2 <- x**2; x^2
x2

X <- 10
prod1 <- X*x
prod1

# 문자도 논리형 가능
"Some.Text" == "some.text"


x <- 3
27/3 -> y
z <- x + y

vec1 <- c(1, 2, 3, 4)
vec2 <- c("A", "B", "C")
x; y; z; vec1; vec2

# "="으로 할당 가능
a = 7
7 = b


###################
## 모든객체 보기 ##
###################
ls()
objects()


# 객체 지우기
rm(x)
rm(list = ls())


# 현재 작업환경에서 구동중인 패키지 확인하기
search()


#########################
## 예약어 NaN, Inf, NA ##
#########################

# NaN (Not a number)
# Inf (무한대)
# NA (Not Avaiable): 결측값, in.na( ) 결측값 확인하기
# NULL: 정의되지 않은 값 (할당되는 값이 없음)

0/0
NaN <- 3

1/0
-22/0

Y <- c(1, 2, NA, 4, 5)
Y

Z <- 5 + NA
Z

is.na(Y)
is.na(Z)

c(1, 2, NULL, 4, 5)

##############
## R의 객체 ##
##############

# 리스트 (List): 서로 다른 자료들을 결합시켜 더 큰 리스트를 만든다.
# 벡터 (Vector): 일차원. 벡터에는 수치형, 문자형, 논리형으로 구성된다.
# 어레이 (Array): 다차원 벡터. 수치형, 문자형, 논리형으로 구성된다.
# 행렬 (Matrix): 이차원 배열. 수치형, 문자형, 논리형으로 구성된다.
# 데이터 프레임 (Data frame): 이차원 자료. 각 열은 다른 형(수치형, 문자형, 논리형)으로 구성할 수 있고,
#                             각 행을 같은 길이를 갖는다.
# 함수 (function)


## 객체의 class와 type보기
class(x)
typeof(x)

class(vec2)
typeof(vec2)

x <- as.integer(x) # 다른 형의 type으로 바꾸기 (실수를 정수로)
typeof(x)
is.integer(x)

## 다른 형의 type으로 바꾸는 함수: as.numeric(), as.double(), as.character()
##             현재 type 확인하기: is.numeric(), is.double(), is.character(),
##                                 is.list, is.vector, is.matrix, is.array, is.data.frame(), is.function()

###############
## Help 기능 ##
###############
help()
help.start()

?mean       
help(mean) 

apropos("mean")

?"[["      # 기호도 도움말 가능
help("[[")  



###################
## 자료 입력하기 ##
###################

## 반복문 연습
abc <- c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5)
abc

seq(-pi, pi, 0.8) # 연속적인 값 입력 seq(시작 값, 마지막 값, 증감)
seq(1, 10)

rep(T, 7)             # 논리형도 가능
rep(c(1, 2, 3), 2)    # 여러 개의 입력값도 가능
rep(3:5, 2)

rep(seq(1, 2, 0.5), 2)


## 행렬 만들기
# 벡터를 결합하여 만들기
# 열 기준이 디폴트, 행 기준으로 입력하고 싶다면: matrix(x, ncol =, nrow =, byrow = T)

matrix(c(1, 2, 3, 4), ncol = 2, byrow = T)
matrix(1:4, ncol = 2, byrow = T)

A = matrix(seq(1:9), ncol = 3)
dimnames(A) = list(c("R1", "R2", "R3"), c("C1", "C2", "C3")) # 행이름, 열이름 지정
A

A[, 2]
A[3, ]

A[, 3] = A[, 3] - 20
A

A[2:3, ]   
A[1:2, 2:3]  

A[2, 3]  


## 행과 열 결합하기
x = c(1, 2)
y = c(2, 3)
z = rbind(x, y)
z  
  
w = cbind(x, y)
w

