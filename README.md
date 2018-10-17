# ansible-role-wordpress_hosted

Install WordPress on a hosted server, where you have limited privileges.
Plug-ins can also be installed. Salts for security are automatically
generated. Does not need Unix `root` account.

It is assumed that you have shell access to the remote server, and you have
home directory.

# Requirements

On the target remote host, you need:

* SSH access
* `python`
* `unzip`
* `gtar`, or GNU tar
* A working database account for WordPress

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `wordpress_hosted_db_name` | | `wordpress` |
| `wordpress_hosted_db_host` | | `localhost:3306` |
| `wordpress_hosted_db_user` | | `wordpress` |
| `wordpress_hosted_db_password` | | `""` |
| `wordpress_hosted_download_url` | | `https://wordpress.org/` |
| `wordpress_hosted_download_filename` | | `latest.tar.gz` |
| `wordpress_hosted_plugins_download_url` | | `https://downloads.wordpress.org/plugin/` |
| `wordpress_hosted_root_dir` | | `{{ ansible_user_dir }}` |
| `wordpress_hosted_document_root` | | `{{ wordpress_hosted_root_dir }}/public_html` |
| `wordpress_hosted_app_root` | | `{{ wordpress_hosted_document_root }}/wordpress` |
| `wordpress_hosted_plugin_dir` | | `{{ wordpress_hosted_app_root }}/wp-content/plugins` |
| `wordpress_hosted_distfiles_dir` | | `{{ wordpress_hosted_root_dir }}/distfiles` |
| `wordpress_hosted_wp_config` | | `{}` |
| `wordpress_hosted_wp_config_raw` | | `""` |
| `wordpress_hosted_wp_config_filemode` | | `288` |
| `wordpress_hosted_wp_config_table_prefix` | | `wp_` |
| `wordpress_hosted_salt_api_url` | | `https://api.wordpress.org/secret-key/1.1/salt/` |
| `wordpress_hosted_wp_salts_file` | | `{{ wordpress_hosted_app_root }}/wp-salts.php` |
| `wordpress_hosted_plugins` | | `[]` |
| `wordpress_hosted_themes` | | `[]` |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  pre_tasks:
    - pkgng:
        name: gtar
        state: present
      become_user: root
      become: yes
      when:
        - ansible_os_family == 'FreeBSD'
    - apt:
        name: unzip
        state: present
      become_user: root
      become: yes
      when:
        - ansible_os_family == 'Debian'
  roles:
    - ansible-role-wordpress_hosted
  vars:
    wordpress_hosted_document_root: "{{ ansible_user_dir }}/web"
    wordpress_hosted_app_root: "{{ wordpress_hosted_document_root }}"
    wordpress_hosted_db_password: PassWord
    wordpress_hosted_wp_config:
      WP_MEMORY_LIMIT: 256M
    wordpress_hosted_wp_config_raw: |
      define('FOO', 'BAR');
    wordpress_hosted_wp_config_table_prefix: wp1_
    wordpress_hosted_plugins:
      - name: code-snippets
      - name: dark-mode
        version: 3.0.1
```

# License

```
Copyright (c) 2018 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [qansible](https://github.com/trombik/qansible)
