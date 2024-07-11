
痛点：clash的配置文件，一般是更新服务商的订阅地址时自动拉取回来的，里面的配置项和分类规则都是服务商写死的。当需要走一些自定义的规则时，手动修改配置文件只能暂时解决问题，等以后再更新订阅地址时又会自动拉取并配置文件，导致之前手动修改的配置项丢失。

此项目就是解决这个问题，使用方法：
1.clone此项目后，命令行执行：bash setup-hooks.sh
2.在custom-rules.yaml文件中自定义规则；
3.提交到github；
4.让clash重新加载下配置文件，

解释下工作原理：利用git提供的pre-commit钩子，在commit时把custom-rules.yaml文件中自定义的规则添加到$HOME/.config/clash目录下所有yaml文件的rules:下面，手动reload下clash的配置文件即可。

后续在custom-rules.yaml中新增配置项并commit时也会自动去重并添加到各配置文件中。

custom-rules.yaml已有的配置项进行修改或删除，还不支持自动修改或删除clash配置文件中的对应配置项，只能手动去更新clash配置文件 或者 更新服务商提供的订阅地址让其重置clash配置文件然后再提交修改到github触发此自动流程。
