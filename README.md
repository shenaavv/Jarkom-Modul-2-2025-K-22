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

   - Pada node eonwe
   <pre>
       iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.222.0.0/16
       echo 1 > /proc/sys/net/ipv4/ip_forward
   </pre>

3. Konfigurasi Routing Internal dan DNS Resolver

   - Pada node selain eonwe
   <pre>
       apt update
       echo nameserver 192.168.122.1 > /etc/resolv.conf
   </pre>

4. Para penjaga nama naik ke menara, di Tirion (ns1/master) bangun zona <xxxx>.com sebagai authoritative dengan SOA yang menunjuk ke ns1.<xxxx>.com dan catatan NS untuk ns1.<xxxx>.com dan ns2..com. Buat A record untuk ns1.<xxxx>.com dan ns2.<xxxx>.com yang mengarah ke alamat Tirion dan Valmar sesuai glosarium, serta A record apex <xxxx>.com yang mengarah ke alamat Sirion (front door), aktifkan notify dan allow-transfer ke Valmar, set forwarders ke 192.168.122.1. Di Valmar (ns2/slave) tarik zona <xxxx>.com dari Tirion dan pastikan menjawab authoritative. pada seluruh host non-router ubah urutan resolver menjadi ns1.<xxxx>.com → ns2.<xxxx>.com → 192.168.122.1. Verifikasi query ke apex dan hostname layanan dalam zona dijawab melalui ns1/ns2.

    <pre>
        echo "tirion" > /etc/hostname
        hostname tirion
        echo "127.0.1.1 tirion" >> /etc/hosts
        ip route add default via 10.15.43.29 2>/dev/null
        ip addr add 192.234.3.3/24 dev eth0 2>/dev/null

        apt update
        apt install -y bind9

        cat > /etc/bind/db.K22.com <<'EOF'
        $TTL 86400
        @   IN  SOA ns1.K22.com. admin.K22.com. (
                2025101301
                3600
                1800
                604800
                86400 )
            IN  NS  ns1.K22.com.
            IN  NS  ns2.K22.com.
        ns1 IN  A   192.234.3.3
        ns2 IN  A   192.234.3.4
        @   IN  A   10.15.43.35
        www     IN  CNAME   sirion
        static  IN  CNAME   lindon
        app     IN  CNAME   vingilot
        sirion   IN  A   10.15.43.35
        lindon   IN  A   10.15.43.38
        vingilot IN  A   10.15.43.39
        EOF

        cat > /etc/bind/named.conf.local <<'EOF'
        zone "K22.com" {
            type master;
            file "/etc/bind/db.K22.com";
            allow-transfer { 192.234.3.4; };
            notify yes;
        };
        EOF

        service bind9 restart
    </pre>

5. “Nama memberi arah,” kata Eonwe. Namai semua tokoh (hostname) sesuai glosarium, eonwe, earendil, elwing, cirdan, elrond, maglor, sirion, tirion, valmar, lindon, vingilot, dan verifikasi bahwa setiap host mengenali dan menggunakan hostname tersebut secara system-wide. Buat setiap domain untuk masing masing node sesuai dengan namanya (contoh: eru..com) dan assign IP masing-masing juga. Lakukan pengecualian untuk node yang bertanggung jawab atas ns1 dan ns2
   <pre>
        #!/bin/bash
        echo "valmar" > /etc/hostname
        hostname valmar
        echo "127.0.1.1 valmar" >> /etc/hosts
        ip route add default via 10.15.43.29 2>/dev/null
        ip addr add 192.234.3.4/24 dev eth0 2>/dev/null

        apt update
        apt install -y bind9

        cat > /etc/bind/named.conf.local <<'EOF'
        zone "K22.com" {
            type slave;
            file "/var/cache/bind/db.K22.com";
            masters { 192.234.3.3; };
        };
        EOF

        service bind9 restart
   </pre>

6. Lonceng Valmar berdentang mengikuti irama Tirion. Pastikan zone transfer berjalan, Pastikan Valmar (ns2) telah menerima salinan zona terbaru dari Tirion (ns1). Nilai serial SOA di keduanya harus sama

    <pre>
        #!/bin/bash
        cat > /etc/bind/db.10.15.43 <<'EOF'
        $TTL 86400
        @   IN  SOA ns1.K22.com. admin.K22.com. (
                2025101301
                3600
                1800
                604800
                86400 )
            IN  NS  ns1.K22.com.
            IN  NS  ns2.K22.com.
        35  IN  PTR sirion.K22.com.
        38  IN  PTR lindon.K22.com.
        39  IN  PTR vingilot.K22.com.
        EOF

        echo '
        zone "43.15.10.in-addr.arpa" {
            type master;
            file "/etc/bind/db.10.15.43";
            allow-transfer { 192.234.3.4; };
        };' >> /etc/bind/named.conf.local

        service bind9 restart
    </pre>


7. Peta kota dan pelabuhan dilukis. Sirion sebagai gerbang, Lindon sebagai web statis, Vingilot sebagai web dinamis. Tambahkan pada zona .com A record untuk sirion..com (IP Sirion), lindon..com (IP Lindon), dan vingilot..com (IP Vingilot). Tetapkan CNAME :

   - www.<xxxx>.com → sirion.<xxxx>.com,
   - static.<xxxx>.com → lindon.<xxxx>.com, dan
   - app.<xxxx>.com → vingilot.<xxxx>.com.

   Verifikasi dari dua klien berbeda bahwa seluruh hostname tersebut ter-resolve ke tujuan yang benar dan konsisten.
   <pre>
        echo '
        zone "43.15.10.in-addr.arpa" {
            type slave;
            file "/var/cache/bind/db.10.15.43";
            masters { 192.234.3.3; };
        };' >> /etc/bind/named.conf.local

        service bind9 restart
   </pre>
   
8. Setiap jejak harus bisa diikuti. Di Tirion (ns1) deklarasikan satu reverse zone untuk segmen DMZ tempat Sirion, Lindon, Vingilot berada. Di Valmar (ns2) tarik reverse zone tersebut sebagai slave, isi PTR untuk ketiga hostname itu agar pencarian balik IP address mengembalikan hostname yang benar, lalu pastikan query reverse untuk alamat Sirion, Lindon, Vingilot dijawab authoritative.

    <pre>
        cat > /etc/resolv.conf <<EOF
        nameserver 192.234.3.3
        nameserver 192.234.3.4
        nameserver 192.168.122.1
        EOF
    </pre>

9. Lampion Lindon dinyalakan. Jalankan web statis pada hostname static.<xxxx>.com dan buka folder arsip /annals/ dengan autoindex (directory listing) sehingga isinya dapat ditelusuri. Akses harus dilakukan melalui hostname, bukan IP.
    <pre>
        echo "lindon" > /etc/hostname
        hostname lindon
        ip route add default via 10.15.43.29

        apt update
        apt install -y nginx

        mkdir -p /var/www/static.K22.com/html/annals
        echo "h1 Lindon - K22 h1" > /var/www/static.K22.com/html/index.html
        echo "Archived record" > /var/www/static.K22.com/html/annals/record.txt

        cat > /etc/nginx/sites-available/static.K22.com <<'EOF'
        server {
            listen 80;
            server_name static.K22.com;
            root /var/www/static.K22.com/html;
            index index.html;
            location /annals/ {
                autoindex on;
                autoindex_localtime on;
            }
        }
        EOF

        ln -sf /etc/nginx/sites-available/static.K22.com /etc/nginx/sites-enabled/
        rm -f /etc/nginx/sites-enabled/default
        service nginx restart
    </pre>

10. Vingilot mengisahkan cerita dinamis. Jalankan web dinamis (PHP-FPM) pada hostname app.<xxxx>.com dengan beranda dan halaman about, serta terapkan rewrite sehingga /about berfungsi tanpa akhiran .php. Akses harus dilakukan melalui hostname.

      <pre>
        #!/bin/bash
        echo "vingilot" > /etc/hostname
        hostname vingilot
        ip route add default via 10.15.43.29

        apt update
        apt install -y wget ca-certificates gnupg
        wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg --no-check-certificate
        echo "deb https://packages.sury.org/php/ bookworm main" > /etc/apt/sources.list.d/php.list
        apt update
        apt install -y nginx php8.4-fpm

        mkdir -p /var/www/app.K22.com/html
        echo '<?php echo "<h1>Vingilot Home</h1>"; ?>' > /var/www/app.K22.com/html/index.php
        echo '<?php echo "<h1>About Page</h1>"; ?>' > /var/www/app.K22.com/html/about.php

        cat > /etc/nginx/sites-available/app.K22.com <<'EOF'
        server {
            listen 80;
            server_name app.K22.com;
            root /var/www/app.K22.com/html;
            index index.php;
            location / {
                try_files $uri $uri/ @rewrite;
            }
            location @rewrite {
                rewrite ^/about$ /about.php last;
            }
            location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php8.4-fpm.sock;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
            }
        }
        EOF

        ln -sf /etc/nginx/sites-available/app.K22.com /etc/nginx/sites-enabled/
        rm -f /etc/nginx/sites-enabled/default
        service php8.4-fpm restart
        service nginx restart
      </pre>
    
11. Di muara sungai, Sirion berdiri sebagai reverse proxy. Terapkan path-based routing: /static → Lindon dan /app → Vingilot, sambil meneruskan header Host dan X-Real-IP ke backend. Pastikan Sirion menerima www..com (kanonik) dan sirion..com, dan bahwa konten pada /static dan /app di-serve melalui backend yang tepat.

    <pre>
        echo "sirion" > /etc/hostname
        hostname sirion
        ip route add default via 10.15.43.29

        apt update
        apt install -y nginx

        cat > /etc/nginx/sites-available/sirion_proxy <<'EOF'
        server {
            listen 80;
            server_name sirion.K22.com;
            return 301 http://www.K22.com$request_uri;
        }
        server {
            listen 80;
            server_name www.K22.com;
            location /static/ {
                proxy_pass http://static.K22.com/;
                proxy_set_header Host static.K22.com;
                proxy_set_header X-Real-IP $remote_addr;
            }
            location /app/ {
                proxy_pass http://app.K22.com/;
                proxy_set_header Host app.K22.com;
                proxy_set_header X-Real-IP $remote_addr;
            }
            location = / {
                return 302 /static/;
            }
        }
        EOF

        ln -sf /etc/nginx/sites-available/sirion_proxy /etc/nginx/sites-enabled/
        rm -f /etc/nginx/sites-enabled/default
        service nginx restart
    </pre>
    
12. Membuat path admin pada node sirion, dan implementasi basic autentikasi (sirion)

    <pre>
        apt-get install apache2-utils -y
        apt install nginx -y
    </pre>
    - add password
    <pre>
        htpasswd -c /etc/nginx/.htpasswd admin 
        cat /etc/nginx/.htpasswd 
    </pre>
    - edit nginx config
    <pre>
        nano /etc/nginx/sites-available/default
    </pre>
    - isi config
    <pre>
        server {
            listen 80;
            server_name www.K22.com sirion.K22.com;
    
            # ... konfigurasi lain yang sudah ada ...
    
            # Path untuk /static (sudah ada dari soal sebelumnya)
            location /static {
                proxy_pass http://192.222.3.5;
                proxy_set_header Host \$host;
                proxy_set_header X-Real-IP \$remote_addr;
            }
    
            # Path untuk /app (sudah ada dari soal sebelumnya)
            location /app {
                proxy_pass http://192.222.3.6;
                proxy_set_header Host \$host;
                proxy_set_header X-Real-IP \$remote_addr;
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
                # proxy_set_header Host \$host;
                # proxy_set_header X-Real-IP \$remote_addr;
            }
        }
    </pre>

    - restart server
    <pre>
        service nginx restart
        service nginx status
    </pre>
    - verifikasi

13.
14.
15.
16.
17.
18.
19.
20.
