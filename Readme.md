Perfect — now that your **RadeonXFX account works**, switching back to another GitHub account is just as easy. On Windows, **SSH host aliases control the account**.

Here’s how to do it cleanly.

---

## 1️⃣ Make sure your second key exists

You already have:

```
C:\Users\pthakur43\.ssh\id_ed25519       # default / personal account
C:\Users\pthakurxfx\.ssh\id_ed25519_radeonxfx  # new account
```

If you haven’t created a config alias for your **other account**, do it now:

```powershell
notepad $env:USERPROFILE\.ssh\config
```

Add something like:

```sshconfig
# Default / Personal GitHub account
Host github-personal
    HostName github.com
    User git
    IdentityFile C:/Users/pthakur43/.ssh/id_ed25519
    IdentitiesOnly yes
```

> You now have two Host aliases:
>
> * `github-radeonxfx` → RadeonXFX account
> * `github-personal` → personal/default account

---

## 2️⃣ Test the personal account

```powershell
ssh -T git@github-personal
```

You should see:

```
Hi YourUsername! You've successfully authenticated...
```

If not, run:

```powershell
ssh-add C:\Users\pthakur43\.ssh\id_ed25519
```

---

## 3️⃣ Clone / use a repo for the personal account

When cloning or updating a repo for the **personal account**, use the alias:

```powershell
git clone git@github-personal:YourUsername/YourRepo.git
```

* Do **not** use `git@github.com` directly
* The alias tells SSH which key (and thus which GitHub account) to use

---

## 4️⃣ Switch accounts for an existing repo

If you already cloned a repo using the wrong account, you can **update the remote URL**:

```powershell
cd path\to\your\repo
git remote set-url origin git@github-personal:YourUsername/YourRepo.git
```

Test connection:

```powershell
git fetch
```

---

## ✅ Key principle (mental model)

| SSH Host used          | GitHub account used                                         |
| ---------------------- | ----------------------------------------------------------- |
| `git@github-radeonxfx` | RadeonXFX account                                           |
| `git@github-personal`  | Personal/default account                                    |
| `git@github.com`       | Whatever your default SSH key is (usually first key loaded) |

> Switching accounts is **just a matter of using the correct Host alias**.

---

💡 **Tip:** You can have as many accounts as you want; just add another alias in the `config` file:

```sshconfig
Host github-work
    HostName github.com
    User git
    IdentityFile C:/Users/pthakur43/.ssh/id_ed25519_work
    IdentitiesOnly yes
```

Then clone with:

```powershell
git clone git@github-work:WorkUsername/Repo.git
```

---

If you want, I can write a **ready-to-use `.ssh/config` file** for **three GitHub accounts** so you can switch instantly without touching anything again.

Do you want me to do that?
