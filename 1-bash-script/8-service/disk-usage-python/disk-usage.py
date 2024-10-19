import shutil
from hurry.filesize import size
from colorama import Fore
du = shutil.disk_usage("/")
print(du)
total = int(size(du.total).replace("G", ""))
used = int(size(du.used).replace("G", ""))


print(f"total disk is: {total}G")
print(f"total disk usage is {used}G")
if total - used < 10:
    print(Fore.RED + 'Pay attention, your root partition is going to be full !!!!!!!!')
else:
    print(Fore.GREEN + f"feel free, your root partition is free. you have {total-used}G free")
    