이 저장소는 강의안을 올려놓은 저장소입니다. R과 python 폴더에 각각 강의를 위한 R와 python코드가 업로드 되어 있습니다. 

강사의 안내에 따라 R 또는 python에서 코드파일을 다운받으면 됩니다. R파일은 다운로드 후 R studio에 열어서 바로 사용하시면 되고, python은 각 작업을 위한 가상환경을 만들어 사용하시면 됩니다. 

---
## python 가상환경 만들기

1. 파이썬은 파이썬 버전과 모듈 호환성때문에 가상환경을 만들어 사용할 것입니다. anaconda prompt를 열고 `conda create -n [가상환경 이름] python=[파이썬 버전]` 형태로 명령어를 작성합니다. 아래 코드는 python폴더의 ML과 DL코드작성을 진행한 가상환경을 생성한 코드입니다.
```
conda create -n high python=3.8
```
이로써 python3.8버전에서 high라는 이름의 가상환경이 생성되었습니다. 

2. `conda activate [가상환경 이름]`명령어를 통해 가상환경에 접속합니다.
```
conda activate high
```

3. 생성한 가상환경에 주피터노트북이 설치되어 있는지 확인합니다.
```
jupyter --version
```

4. 주피터노트북이 설치되어 있다면 주피터노트북을 실행시킵니다.
```
jupyter notebook
```
만약 주피터노트북이 설치되어있지 않다면 `conda install jupyter` 명령어로 주피터노트북을 설치한 후 `jupyter notebook`을 입력하면 주피터노트북이 실행될 것입니다.

5. 이제 코드파일을 실행하시면 됩니다.