function init()
    kernel.exec("apps/user/procjam.nib", {})
    kernel.kill(0)
end
