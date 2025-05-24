alias py="python"
alias py3="python3"
alias djrun="python manage.py runserver"
alias dj="python manage.py"
alias uvrun="uvicorn app:app --reload --port 8001"
alias va=". venv/bin/activate"
alias sshh='_a=( $(cat $HOME/.ssh/my_hosts | fzf) ); ssh ${_a[@]:1}'
