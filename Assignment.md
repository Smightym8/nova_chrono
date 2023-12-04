# Assignment
Since you personal time tracking information are very sensible information, many people prefer not to store them in a third party service. Instead they wish to store them only locally resp. in a way they are in full control. Since this application should run completely offline (even the installation process) a desktop application should be developed. This application has the potential to run on many different operating systems and environments, therefore it should be developed in a technology that allows to reuse large parts of the code base among them.

Time tracking information should be stored persistently and contain the following information:
* An identifying task name for an easy lookup
* Start and end timestamp of the task
* Personal notes with some additional details about a completed task

The application should list all done tasks of a day. A user should be able to add new tasks to a certain date with a start and end time and some personal notes as well as editing and deleting existing ones.

It should also be possible to manage a set of common task names which can be used when adding or modifying a task. Users can afterwards use this information to filter the list of shown tasks of a single day to also show all tasks with the same task name.

The time tracking information should be stored using encryption, so that it is not too easy to retrieve in plaintext if the data is leaked somehow. Ideally this happens in another, more performant, language than JavaScript.

This application has to be developed using a cross-platform technology that also uses web technologies and enables the authors to build the application for many different environments.

If the chosen technology allows it, the application should be tested using some UI tests and some unit tests.

The results will be presented afterwards, in particular the basics and characteristics of the used framework including its advantages and disadvantages.

Please attach a README.md file explaining how to start the application.

