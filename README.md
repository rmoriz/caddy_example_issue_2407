# Example for issue 2407
see https://github.com/mholt/caddy/issues/2407

## Usage

- install docker
- install docker-compose
- see/change `docker-compose.yaml`,  variable `caddy_revision`
- build and start:
  ```shell
  docker-compose up --build
  ```

## Bug

```
Starting caddy-example_proxy_1 ... done
Attaching to caddy-example_proxy_1
proxy_1  | 2019/01/22 23:37:39 [ERROR] Loading persistent UUID: open /config/uuid: permission denied
proxy_1  | 2019/01/22 23:37:39 [ERROR] Persisting instance UUID: open /config/uuid: permission denied
proxy_1  | Activating privacy features... 2019/01/22 23:37:39 [INFO] [asdas.net] acme: Obtaining bundled SAN certificate
proxy_1  | 2019/01/22 23:37:40 [INFO] [asdas.net] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/h5jIf94Ja8RvbcsIVOEoNj0PeerDZovjY5vfEDybq-k
proxy_1  | 2019/01/22 23:37:40 [INFO] [asdas.net] acme: use tls-alpn-01 solver
proxy_1  | 2019/01/22 23:37:40 [INFO] [asdas.net] acme: Trying to solve TLS-ALPN-01
proxy_1  | 2019/01/22 23:37:40 [asdas.net] failed to obtain certificate: acme: Error -> One or more domains had a problem:
proxy_1  | [asdas.net] [asdas.net] acme: error presenting token: presenting with standard provider server: could not start HTTPS server for challenge -> listen tcp :443: bind: permission denied
caddy-example_proxy_1 exited with code 1
```
