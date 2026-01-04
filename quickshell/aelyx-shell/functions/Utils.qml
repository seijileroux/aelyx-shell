pragma Singleton
import Quickshell

Singleton {
    id: root
    
    function trimFileProtocol(str) {
        let s = str;
        if (typeof s !== "string") s = str.toString(); // Convert to string if it's an url or whatever
        return s.startsWith("file://") ? s.slice(7) : s;
    }

    function isVideo(path) {
        if (!path)
            return false

        // Convert QUrl → string if needed
        let p = path.toString ? path.toString() : path

        // Strip file://
        if (p.startsWith("file://"))
            p = p.replace("file://", "")

        const ext = p.split(".").pop().toLowerCase()

        return [
            "mp4",
            "mkv",
            "webm",
            "mov",
            "avi",
            "m4v"
        ].includes(ext)
    }

    
}