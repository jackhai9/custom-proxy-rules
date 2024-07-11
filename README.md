## 如何优雅地为 Clash 添加自定义代理规则？

### 痛点

clash的配置文件，一般是更新服务商的订阅地址时自动拉取回来的，里面的配置信息和分类规则都是服务商写死的。当需要走一些自定义的规则时，手动修改配置文件只能暂时解决问题，以后再更新订阅地址时又会自动拉取并重置配置文件，导致之前手动修改的配置项丢失。

### 解决

此项目就是解决这个问题，使用步骤：

1. clone此项目后，命令行执行：`bash setup-hooks.sh`、`chmod +x .git/hooks/pre-commit`、`chmod +x merge2config.sh`
2. 在custom-rules.yaml文件中添加自定义规则；
3. 提交到github；
4. 点击clash的`Reload config`按钮（快捷键command+R）重新加载配置文件；

搞定！

> custom-rules这个文件名不是必须的，你也可以起其他名称，也可以添加一个或多个别的yaml文件

### 原理

解释下工作原理：利用git提供的pre-commit钩子，在commit时把custom-rules.yaml文件中自定义的规则添加到`$HOME/.config/clash`目录下所有yaml文件的`rules:`下面，手动reload下clash的配置文件即可。

以后需要新增自定义规则时，执行步骤234即可。

> custom-rules.yaml中的配置项进行修改或删除，还不支持自动修改或删除clash配置文件中的对应配置项，只能手动去更新clash配置文件 或者 更新服务商提供的订阅地址让其重置clash配置文件再执行步骤234即可。

### 其他

也可以参考其他方案：[v2ex的一个方案](https://www.v2ex.com/t/949462)
