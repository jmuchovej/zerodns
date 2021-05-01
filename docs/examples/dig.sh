$ dig @127.0.0.1 -p 5053 peer1.zerodns.com

; <<>> DiG 9.10.6 <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 49486
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;peer1.zerodns.com.             IN      A

;; ANSWER SECTION:
peer1.zerodns.com.      228     IN      A       192.168.193.12

;; Query time: 112 msec
;; SERVER: 127.0.0.1#5053(127.0.0.1)
;; WHEN: Wed May 04 12:00:00 PST 2011
;; MSG SIZE  rcvd: 55