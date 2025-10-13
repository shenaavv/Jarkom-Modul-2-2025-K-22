# Laporan Resmi Praktikum Komunikasi Data dan Jaringan Komputer Modul 2

# Jarkom K22

## Member

| No  | Nama                   | NRP        |
| --- | ---------------------- | ---------- |
| 1   | Kanafira Vanesha Putri | 5027241010 |
| 2   | Reza Aziz Simatupang   | 5027241051 |

## Reporting 

1. Membuat topologi Jaringan dan Config Node
    ![alt text](assets/soal_1.png) 
2. Konfigurasi NAT dan Konektivitas Internet
    * Pada node eonwe
    <pre>
        iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.222.0.0/16
        echo 1 > /proc/sys/net/ipv4/ip_forward
    </pre>

3. Konfigurasi Routing Internal dan DNS Resolver
    * Pada node selain eonwe
    <pre>
        apt update
        echo nameserver 192.168.122.1 > /etc/resolv.conf
    </pre>

# MAAF LAPORAN LANJUTAN MENYUSUL

4. 
5. 
6. 
7. 
8. 
9. 
10. 
11. 
12. Membuat path admin pada node sirion, dan implementasi basic autentikasi (sirion)
    * install nginx dan apache
    <pre>
        apt-get install apache2-utils -y
        apt install nginx -y
    </pre>
    * add password
    <pre>
        htpasswd -c /etc/nginx/.htpasswd admin 
        cat /etc/nginx/.htpasswd 
    </pre>
    * edit nginx config
    <pre>
        nano /etc/nginx/sites-available/default
    </pre>
    * isi config
    <pre>
        server {
            listen 80;
            server_name www.K22.com sirion.K22.com;

            # ... konfigurasi lain yang sudah ada ...

            # Path untuk /static (sudah ada dari soal sebelumnya)
            location /static {
                proxy_pass http://192.222.3.5;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
            }

            # Path untuk /app (sudah ada dari soal sebelumnya)
            location /app {
                proxy_pass http://192.222.3.6;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
            }

            # Path untuk /admin dengan Basic Auth
            location /admin {
                auth_basic "Restricted Area";
                auth_basic_user_file /etc/nginx/.htpasswd;
                
                # Kamu bisa proxy ke backend tertentu atau serve konten statis
                # Contoh jika ingin serve konten statis:
                root /var/www/html;
                index index.html;
                
                # Atau jika ingin proxy ke backend:
                # proxy_pass http://<backend_server>;
                # proxy_set_header Host $host;
                # proxy_set_header X-Real-IP $remote_addr;
            }
        }
    </pre>
    * restart server
    <pre>
        service nginx restart
        service nginx status
    </pre>
    * verifikasi
13. 
14. 
15. 
16. 
17. 
18. 
19. 
20. 