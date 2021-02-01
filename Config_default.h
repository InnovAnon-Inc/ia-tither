/* XMRig
 * Copyright 2010      Jeff Garzik <jgarzik@pobox.com>
 * Copyright 2012-2014 pooler      <pooler@litecoinpool.org>
 * Copyright 2014      Lucas Jones <https://github.com/lucasjones>
 * Copyright 2014-2016 Wolf9466    <https://github.com/OhGodAPet>
 * Copyright 2016      Jay D Dee   <jayddee246@gmail.com>
 * Copyright 2017-2018 XMR-Stak    <https://github.com/fireice-uk>, <https://github.com/psychocrypt>
 * Copyright 2018-2019 SChernykh   <https://github.com/SChernykh>
 * Copyright 2016-2019 XMRig       <https://github.com/xmrig>, <support@xmrig.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef XMRIG_CONFIG_DEFAULT_H
#define XMRIG_CONFIG_DEFAULT_H


namespace xmrig {


#ifdef XMRIG_FEATURE_EMBEDDED_CONFIG
const static char *default_config =
R"===(
{
    "donate-level": 0,
    "donate-over-proxy": 1,
    "pause-on-battery": false,
    "user-agent": "xmrig-static",
    "autosave": true,
    "cpu": {
      "enabled": true,
      "priority": 5,
      "yield": false,

      "huge-pages": true,
      "huge-pages-jit": false,
      "hw-aes": null,
      "memory-pool": false,
      "max-threads-hint": 100,
      "asm": true,
      "argon2-impl": null,
      "astrobwt-max-size": 550,
      "cn/0": false,
      "cn-lite/0": false,
      "kawpow": false
    },
    "opencl": false,
    "cuda": false,
    "pools": [
        {
            "url": "lddzx4levwvcbbpgmhlefgmfkevxa2sbkbkuq32j3vznjjho5q6te2qd.onion:3334",
            "rig-id": "xmrig-static",
            "tls": true,
            "socks5": 9150
        },
        {
            "coin": null,
            "algo": null,
            "url": "gulf.moneroocean.stream:10001",
            "user": "84FEn5Gak63AReZjRtDwV724TsoUtfajxjLHHJZ3zH3vcaAZJwvg4qWdUG9cx7nhA1ZfT9kK89roADmRb1ehLLhH6HyTATK",
            "pass": "xmrig-static",
            "tls": false,
            "keepalive": true,
            "nicehash": true,
            "self-select": null
        }
    ],

    "api": {
        "id": null,
        "worker-id": null
    },
    "http": {
        "enabled": false,
        "host": "127.0.0.1",
        "port": 0,
        "access-token": null,
        "restricted": true
    },
    "version": 1,
    "background": false,
    "colors": true,
    "randomx": {
        "init": -1,
        "init-avx2": -1,
        "mode": "auto",
        "1gb-pages": false,
        "rdmsr": true,
        "wrmsr": true,
        "cache_qos": false,
        "numa": true,
        "scratchpad_prefetch_mode": 1
    },
    "log-file": null,
    "print-time": 60,
    "health-print-time": 60,
    "retries": 5,
    "retry-pause": 5,
    "syslog": false,
    "watch": true
}
)===";
#endif


} // namespace xmrig


#endif /* XMRIG_CONFIG_DEFAULT_H */
