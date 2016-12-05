from fabric.api import local

def test():
    env.user = 'testuser'
    env.hosts = ['test.server.com']

def live():
    env.user = 'testuser'
    env.hosts = ['test.server.com']

def uploadbackup():
    print("Starting backup db")
    local('python manage.py dumpdata > ./data/backups/db.json')
    upload = put(remote_path="./data/backups/db.json", local_path="/home/data/backups/db.json")
    upload.succeeded
    run('docker-compose run web python manage.py loaddata /data/backups/db.json')
    print("Backup db finish")

def downloadbackup():
    print("Starting restore db")
    run('python manage.py dumpdata > ./data/backups/db.json')
    download = get(remote_path="/home/data/backups/db.json", local_path="./data/backups/db.json")
    download.succeeded
    local('python manage.py loaddata /data/backups/db.json')
    print("Restore db finish")

def test():
    pass

def deploy():
    #connectserver
    #git pull
    #migrate
    #build container

    pass
