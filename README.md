# Hook: pre-commit gitleaks
Git-хук, який за допомогою утиліти [`gitleaks`](https://github.com/gitleaks/gitleaks) 
перевіряє вихідний код в директорії на предмет чутливих даних.

Цей репозиторій містить сам [хук-скрипт](./pre-commit-gitleaks/hook.sh), а також [інсталяційний скрипт](./pre-commit-gitleaks/install.sh), який встановлює хук в локальний git-репозиторій користувача. Також інсталяційний скрипт встановить `gitleaks`, якщо не знайде його в операційній системі користувача (знадобляться права адміністратора).


Підтримувані операційні системи: Windows 10+, Linux.


## `install.sh`
Усі команди слід виконувати із директорії з git-репозиторієм.

Щоб встановити і активувати хук, виконайте наступну команду:
```sh
curl -sfL https://raw.githubusercontent.com/yevgen-grytsay/git-hooks/v1.0.2/pre-commit-gitleaks/install.sh | bash -- enable
```

Встановити без активації:
```sh
curl -sfL https://raw.githubusercontent.com/yevgen-grytsay/git-hooks/v1.0.2/pre-commit-gitleaks/install.sh | bash
```

Активувати хук:
```sh
install.sh enable
# OR
curl -sfL https://raw.githubusercontent.com/yevgen-grytsay/git-hooks/v1.0.2/pre-commit-gitleaks/install.sh | bash -- enable
```

Деактивувати хук:
```sh
install.sh disable
# OR
curl -sfL https://raw.githubusercontent.com/yevgen-grytsay/git-hooks/v1.0.2/pre-commit-gitleaks/install.sh | bash -- disable
```

<!-- 
```sh
git hook run pre-commit
``` -->
