#!/bin/bash
echo "Configuring Gnome\n"
if dpkg-query --show --showformat='${db:Status-Status}\n' 'gdm3' 2>/dev/null | grep -q installed && { [ ! -f /.dockerenv ] && [ ! -f /run/.containerenv ]; }; then

# Check for setting in any of the DConf db directories
# If files contain ibus or distro, ignore them.
# The assignment assumes that individual filenames don't contain :
readarray -t SETTINGSFILES < <(grep -r "\\[org/gnome/desktop/screensaver\\]" "/etc/dconf/db/" | grep -v 'distro\|ibus' | cut -d":" -f1)
DCONFFILE="/etc/dconf/db/local.d/00-security-settings"
DBDIR="/etc/dconf/db/local.d"

mkdir -p "${DBDIR}"

if [ "${#SETTINGSFILES[@]}" -eq 0 ]
then
    [ ! -z ${DCONFFILE} ] || echo "" >> ${DCONFFILE}
    printf '%s\n' "[org/gnome/desktop/screensaver]" >> ${DCONFFILE}
    printf '%s=%s\n' "lock-enabled" "true" >> ${DCONFFILE}
else
    escaped_value="$(sed -e 's/\\/\\\\/g' <<< "true")"
    if grep -q "^\\s*lock-enabled\\s*=" "${SETTINGSFILES[@]}"
    then

        sed -i "s/\\s*lock-enabled\\s*=\\s*.*/lock-enabled=${escaped_value}/g" "${SETTINGSFILES[@]}"
    else
        sed -i "\\|\\[org/gnome/desktop/screensaver\\]|a\\lock-enabled=${escaped_value}" "${SETTINGSFILES[@]}"
    fi
fi

dconf update
# Check for setting in any of the DConf db directories
LOCKFILES=$(grep -r "^/org/gnome/desktop/screensaver/lock-enabled$" "/etc/dconf/db/" | grep -v 'distro\|ibus' | cut -d":" -f1)
LOCKSFOLDER="/etc/dconf/db/local.d/locks"

mkdir -p "${LOCKSFOLDER}"

if [[ -z "${LOCKFILES}" ]]
then
    echo "/org/gnome/desktop/screensaver/lock-enabled" >> "/etc/dconf/db/local.d/locks/00-security-settings-lock"
fi

dconf update

else
    >&2 echo 'GNOME LOCK Remediation is not applicable, nothing was done'
fi

if dpkg-query --show --showformat='${db:Status-Status}\n' 'gdm3' 2>/dev/null | grep -q installed && { [ ! -f /.dockerenv ] && [ ! -f /run/.containerenv ]; }; then

# Check for setting in any of the DConf db directories
# If files contain ibus or distro, ignore them.
# The assignment assumes that individual filenames don't contain :
readarray -t SETTINGSFILES < <(grep -r "\\[org/gnome/settings-daemon/plugins/media-keys\\]" "/etc/dconf/db/" | grep -v 'distro\|ibus' | cut -d":" -f1)
DCONFFILE="/etc/dconf/db/local.d/00-security-settings"
DBDIR="/etc/dconf/db/local.d"

mkdir -p "${DBDIR}"

if [ "${#SETTINGSFILES[@]}" -eq 0 ]
then
    [ ! -z ${DCONFFILE} ] || echo "" >> ${DCONFFILE}
    printf '%s\n' "[org/gnome/settings-daemon/plugins/media-keys]" >> ${DCONFFILE}
    printf '%s=%s\n' "logout" "''" >> ${DCONFFILE}
else
    escaped_value="$(sed -e 's/\\/\\\\/g' <<< "''")"
    if grep -q "^\\s*logout\\s*=" "${SETTINGSFILES[@]}"
    then

        sed -i "s/\\s*logout\\s*=\\s*.*/logout=${escaped_value}/g" "${SETTINGSFILES[@]}"
    else
        sed -i "\\|\\[org/gnome/settings-daemon/plugins/media-keys\\]|a\\logout=${escaped_value}" "${SETTINGSFILES[@]}"
    fi
fi

dconf update
# Check for setting in any of the DConf db directories
LOCKFILES=$(grep -r "^/org/gnome/settings-daemon/plugins/media-keys/logout$" "/etc/dconf/db/" | grep -v 'distro\|ibus' | cut -d":" -f1)
LOCKSFOLDER="/etc/dconf/db/local.d/locks"

mkdir -p "${LOCKSFOLDER}"

if [[ -z "${LOCKFILES}" ]]
then
    echo "/org/gnome/settings-daemon/plugins/media-keys/logout" >> "/etc/dconf/db/local.d/locks/00-security-settings-lock"
fi

dconf update

else
    >&2 echo 'GNOME LOCK Remediation is not applicable, nothing was done'
fi

if dpkg-query --show --showformat='${db:Status-Status}\n' 'gdm3' 2>/dev/null | grep -q installed; then

login_banner_text='You are accessing a Death Star Development (DSD) Information System (IS) that is provided for DSD-authorized use only. By using this IS (which includes any device attached to this IS), you consent to the following conditions:
-DSD routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations.
-At any time, DSD may inspect and seize data stored on this IS.
-Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any DSD-authorized purpose.
-This IS includes security measures (e.g., authentication and access controls) to protect DSD interests--not for your personal benefit or privacy.
-Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details.'

if [ -e "/etc/gdm3/greeter.dconf-defaults" ] ; then
    
    LC_ALL=C sed -i "/^\s*banner\-message\-text/Id" "/etc/gdm3/greeter.dconf-defaults"
else
    touch "/etc/gdm3/greeter.dconf-defaults"
fi
# make sure file has newline at the end
sed -i -e '$a\' "/etc/gdm3/greeter.dconf-defaults"

cp "/etc/gdm3/greeter.dconf-defaults" "/etc/gdm3/greeter.dconf-defaults.bak"
# Insert after the line matching the regex '\[org/gnome/login-screen\]'
line_number="$(LC_ALL=C grep -n "\[org/gnome/login-screen\]" "/etc/gdm3/greeter.dconf-defaults.bak" | LC_ALL=C sed 's/:.*//g')"
if [ -z "$line_number" ]; then
    # There was no match of '\[org/gnome/login-screen\]', insert at
    # the end of the file.
    printf '%s\n' "banner-message-text='${login_banner_text}'" >> "/etc/gdm3/greeter.dconf-defaults"
else
    head -n "$(( line_number ))" "/etc/gdm3/greeter.dconf-defaults.bak" > "/etc/gdm3/greeter.dconf-defaults"
    printf '%s\n' "banner-message-text='${login_banner_text}'" >> "/etc/gdm3/greeter.dconf-defaults"
    tail -n "+$(( line_number + 1 ))" "/etc/gdm3/greeter.dconf-defaults.bak" >> "/etc/gdm3/greeter.dconf-defaults"
fi
# Clean up after ourselves.
rm "/etc/gdm3/greeter.dconf-defaults.bak"


# Check for setting in any of the DConf db directories
# If files contain ibus or distro, ignore them.
# The assignment assumes that individual filenames don't contain :
readarray -t SETTINGSFILES < <(grep -r "\\[org/gnome/login-screen\\]" "/etc/dconf/db/" | grep -v 'distro\|ibus' | cut -d":" -f1)
DCONFFILE="/etc/dconf/db/gdm.d/00-security-settings"
DBDIR="/etc/dconf/db/gdm.d"

mkdir -p "${DBDIR}"

if [ "${#SETTINGSFILES[@]}" -eq 0 ]
then
    [ ! -z ${DCONFFILE} ] || echo "" >> ${DCONFFILE}
    printf '%s\n' "[org/gnome/login-screen]" >> ${DCONFFILE}
    printf '%s=%s\n' "banner-message-text" "'${login_banner_text}'" >> ${DCONFFILE}
else
    escaped_value="$(sed -e 's/\\/\\\\/g' <<< "'${login_banner_text}'")"
    if grep -q "^\\s*banner-message-text\\s*=" "${SETTINGSFILES[@]}"
    then
        
        sed -i "s/\\s*banner-message-text\\s*=\\s*.*/banner-message-text=${escaped_value}/g" "${SETTINGSFILES[@]}"
    else
        sed -i "\\|\\[org/gnome/login-screen\\]|a\\banner-message-text=${escaped_value}" "${SETTINGSFILES[@]}"
    fi
fi

dconf update
# No need to use dconf update, since bash_dconf_settings does that already

else
    >&2 echo 'SET-BANNER Remediation is not applicable, nothing was done'
fi

if dpkg-query --show --showformat='${db:Status-Status}\n' 'gdm3' 2>/dev/null | grep -q installed; then

# Check for setting in any of the DConf db directories
# If files contain ibus or distro, ignore them.
# The assignment assumes that individual filenames don't contain :
readarray -t SETTINGSFILES < <(grep -r "\\[org/gnome/login-screen\\]" "/etc/dconf/db/" | grep -v 'distro\|ibus' | cut -d":" -f1)
DCONFFILE="/etc/dconf/db/gdm.d/00-security-settings"
DBDIR="/etc/dconf/db/gdm.d"

mkdir -p "${DBDIR}"

if [ "${#SETTINGSFILES[@]}" -eq 0 ]
then
    [ ! -z ${DCONFFILE} ] || echo "" >> ${DCONFFILE}
    printf '%s\n' "[org/gnome/login-screen]" >> ${DCONFFILE}
    printf '%s=%s\n' "banner-message-enable" "true" >> ${DCONFFILE}
else
    escaped_value="$(sed -e 's/\\/\\\\/g' <<< "true")"
    if grep -q "^\\s*banner-message-enable\\s*=" "${SETTINGSFILES[@]}"
    then

        sed -i "s/\\s*banner-message-enable\\s*=\\s*.*/banner-message-enable=${escaped_value}/g" "${SETTINGSFILES[@]}"
    else
        sed -i "\\|\\[org/gnome/login-screen\\]|a\\banner-message-enable=${escaped_value}" "${SETTINGSFILES[@]}"
    fi
fi

dconf update
# Check for setting in any of the DConf db directories
LOCKFILES=$(grep -r "^/org/gnome/login-screen/banner-message-enable$" "/etc/dconf/db/" | grep -v 'distro\|ibus' | cut -d":" -f1)
LOCKSFOLDER="/etc/dconf/db/gdm.d/locks"

mkdir -p "${LOCKSFOLDER}"

if [[ -z "${LOCKFILES}" ]]
then
    echo "/org/gnome/login-screen/banner-message-enable" >> "/etc/dconf/db/gdm.d/locks/00-security-settings-lock"
fi

dconf update

else
    >&2 echo 'GNOME-MESSAGE Remediation is not applicable, nothing was done'
fi

if [ ! -f /.dockerenv ] && [ ! -f /run/.containerenv ]; then
login_banner_text='You are accessing a Death Star Development (DSD) Information System (IS) that is provided for DSD-authorized use only. By using this IS (which includes any device attached to this IS), you consent to the following conditions:
-DSD routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations.
-At any time, DSD may inspect and seize data stored on this IS.
-Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any DSD-authorized purpose.
-This IS includes security measures (e.g., authentication and access controls) to protect DSD interests--not for your personal benefit or privacy.
-Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details.'
cat <<EOF >/etc/issue.net
$login_banner_text
EOF

else
    >&2 echo 'SYS-MESSAGE Remediation is not applicable, nothing was done'
fi

if dpkg-query --show --showformat='${db:Status-Status}\n' 'systemd' 2>/dev/null | grep -q installed; then

# Test if the config_file is a symbolic link. If so, use --follow-symlinks with sed.
# Otherwise, regular sed command will do.
sed_command=('sed' '-i')
if test -L "/etc/systemd/system.conf"; then
    sed_command+=('--follow-symlinks')
fi

# Strip any search characters in the key arg so that the key can be replaced without
# adding any search characters to the config file.
stripped_key=$(sed 's/[\^=\$,;+]*//g' <<< "^CtrlAltDelBurstAction=")

# shellcheck disable=SC2059
printf -v formatted_output "%s=%s" "$stripped_key" "none"

# If the key exists, change it. Otherwise, add it to the config_file.
# We search for the key string followed by a word boundary (matched by \>),
# so if we search for 'setting', 'setting2' won't match.
if LC_ALL=C grep -q -m 1 -i -e "^CtrlAltDelBurstAction=\\>" "/etc/systemd/system.conf"; then
    escaped_formatted_output=$(sed -e 's|/|\\/|g' <<< "$formatted_output")
    "${sed_command[@]}" "s/^CtrlAltDelBurstAction=\\>.*/$escaped_formatted_output/gi" "/etc/systemd/system.conf"
else
    # \n is precaution for case where file ends without trailing newline

    printf '%s\n' "$formatted_output" >> "/etc/systemd/system.conf"
fi

else
    >&2 echo 'CTL-DEL Remediation is not applicable, nothing was done'
fi

if [ ! -f /.dockerenv ] && [ ! -f /run/.containerenv ]; then

systemctl disable --now ctrl-alt-del.target
systemctl mask --now ctrl-alt-del.target

else
    >&2 echo 'CTL-DEL Remediation is not applicable, nothing was done'
fi

