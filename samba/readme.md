Run samba container from image to debug if necessary
```
docker run -it --rm --entrypoint /bin/bash -e smbuser=smbuser -e password=1234567 -p 139:139 -p 445:445 -v /host/data:/data --name samba_server khanguyentuan/samba
```

Check if having user
```
/data# id smbuser
uid=999(smbuser) gid=999(smbgroup) groups=999(smbgroup)
```

Run samba service
```
/data# smbd --foreground --log-stdout --debuglevel=3
```



Manual create service samba by command
```
docker service create --replicas 3 -p 139:139 -p 145:145 -e smbuser=smbuser -e password=1234567 --mount type=bind,source=/home/data,target=/data --name samba khanguyentuan/samba
```

Execute to container of samba service 
```
docker exec it <container_id> /bin/bash
```

Check permission of /data

```
ls -ld /data
chown -R smbuser:smbgroup /data
chmod 0770 /data
```
