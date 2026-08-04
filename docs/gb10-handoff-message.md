# Message to send John (GB10 ownership handoff)

Hi John,

Since the GB10 was purchased through American Eagle Ventures LLC, I need to move it fully under AEVentures' control — both the Linux admin account and the Tailscale network identity currently tied to your `plasmaraygun` login.

This isn't about cutting you off — I'd like to keep you with access to use the machine, just under a setup where AEVentures holds root/admin control as the actual owner of record.

Could we do this together tomorrow morning at 106? I'll need:

1. **Sudo/root access** for about 15 minutes to create a new AEVentures admin account and copy over an SSH key.
2. **5 minutes on the Tailscale login screen** to re-authenticate the box under the AEVentures GitHub org instead of your personal account.

I've already written a script that handles most of it (`gb10-migration-script.sh`) — you'd just need to run it with me and approve the Tailscale re-login in the browser.

After that, I'm happy to set you back up with a non-admin account on the box so you can keep using it for your own work, if that's useful to you.

Let me know what time works tomorrow.

Thanks,
Michael
