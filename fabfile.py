from fabric.api import local, put, hosts, env, run, cd

host = '54.165.172.158'
env.hosts = [host]
env.user = "ec2-user"
env.key_filename = "LightsailDefaultPrivateKey.pem"

def uploadbackup():
    code_dir = '/home/ec2-user/project'
    with cd(code_dir):
        local('pg_dump -U postgres -h postgres postgres > ./data/backups/dbexport.pgsql')
        upload = put(local_path="./data/backups/dbexport.pgsql", remote_path="/home/ec2-user/project/data/backups/dbexport.pgsql")
        upload.succeeded
        run('docker-compose run web psql -h postgres -d postgres -U postgres -f /home/ec2-user/project/data/backups/dbexport.pgsql')

def downloadbackup():
    print("Starting restore db")
    run('python manage.py dumpdata > ./data/backups/db.json')
    download = get(remote_path="/home/ec2-user/project/data/backups/db.json", local_path="./data/backups/db.json")
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
