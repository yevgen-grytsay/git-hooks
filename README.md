# Hook: pre-commit gitleaks
Git-хук, який за допомогою утиліти [`gitleaks`](https://github.com/gitleaks/gitleaks) 
перевіряє вихідний код в директорії на предмет чутливих даних.

Цей репозиторій містить сам [хук-скрипт](./pre-commit-gitleaks/hook.sh), а також [інсталяційний скрипт](./pre-commit-gitleaks/install.sh), який встановлює хук в локальний git-репозиторій користувача. Також інсталяційний скрипт встановить `gitleaks`, якщо не знайде його в операційній системі користувача (знадобляться права адміністратора).


Підтримувані операційні системи: Windows 10+, Linux.


## `install.sh`
Усі команди слід виконувати із директорії з git-репозиторієм.

### Linux
Щоб встановити і активувати хук, виконайте наступну команду:
```sh
curl -sSfL https://raw.githubusercontent.com/yevgen-grytsay/git-hooks/v1.0.4/pre-commit-gitleaks/install.sh | bash
```

Активувати чи деактивувати хук:
```sh
# First download installation script
curl -o install.sh -sSfL https://raw.githubusercontent.com/yevgen-grytsay/git-hooks/v1.0.4/pre-commit-gitleaks/install.sh
chmod +x ./install.sh

# Then run following command to enable hook
./install.sh enable

# Run following command to disable hook
./install.sh disable
```

### Windows
Встановіть консоль Git Bash і запустіть її. Виконайте кроки інсталяції, які описані в інструкції для [Linux](#linux).
