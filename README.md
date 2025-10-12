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
4. Lakukan Setup IP statis & default gateway pada setiap client non-router

    Ulangi pada semua client non-router namun ganti bagian addresses & gateway4 nya sesuai host

    Lalu coba verifikasi dari erendil

5. Masukkan command pada eonwe agar router eonwe dapat meneruskan paket antar subnet dan keluar ke internet

    Lalu lakukan verifikasi dari erendil untuk melihat apakah host berhasil memiliki koneksi keluar

6. 
7. 
8. 
9. 
10. 
11. 
12. 
13. 
14. 
15. 
16. 
17. 
18. 
19. 
20. 