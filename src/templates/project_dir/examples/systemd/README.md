## systemd example

This example uses 2 separate files to define things for systemd .

* The .service file
* The .timer file that depends on the service file

To get things running, it should be sufficient enough to:

```
systemctl enable [% project.package_name %].timer
systemctl start [% project.package_name %].timer
```

### Installation

* Copy the root_etc directory to src/root_etc .
* (Review the files that were copied for correctness)
